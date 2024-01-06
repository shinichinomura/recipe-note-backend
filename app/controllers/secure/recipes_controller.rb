# frozen_string_literal: true

require 'open-uri'

class Secure::RecipesController < Secure::ApplicationController
  def index
    recipes = Recipe.where(user_account_id: @current_user.id).order(registered_at: :desc)

    render json: {
      status: "success",
      recipes: recipes.map do |recipe|
        {
          id: recipe.id,
          title: recipe.title,
          url: recipe.url,
          image_url: recipe.image.present? ? url_for(recipe.image) : nil,
          registered_at: recipe.registered_at
        }
      end
    }
  end

  def preview
    url = params[:url]

    og_title = nil
    og_image_url = nil

    begin
      uri = URI.open(
        escape_url_ja(url),
        'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36'
      )

      html = Nokogiri::HTML.parse(uri.read)

      og_title_elem = html.search('meta[property="og:title"]').first
      if og_title_elem.present?
        og_title = og_title_elem.attr(:content) || ''
      end

      og_image_elem = html.search('meta[property="og:image"]').first

      if og_image_elem.present?
        og_image_url = og_image_elem.attr(:content)

        if og_image_url[0] === '/'
          parsed_uri = URI.parse(escape_url_ja(url))
          parsed_uri.path = og_image_url
          og_image_url = parsed_uri
        end
      end

      if og_title.blank?
        render json: {
          status: "error"
        }
      else
        render json: {
          status: "success",
          og_title: og_title,
          og_image_url: og_image_url
        }
      end
    rescue => e
      render json: {
        statue: "error"
      }
    end
  end

  def create
    recipe = Recipe.new(
      user_account_id: @current_user.id,
      title: params[:title],
      url: params[:url],
      registered_at: Time.current
    )

    if params[:image_url].present?
      image_url = params[:image_url]
      image_io = URI.open(escape_url_ja(image_url))
      image_filename = "image.#{image_io.content_type.split('/').last}"

      recipe.image.attach(io: image_io, filename: image_filename, content_type: image_io.content_type)
    end

    if recipe.save
      render json: {
        status: "success",
        recipe: recipe
      }
    else
      render json: {
        status: "error",
        message: recipe.errors.full_messages.join("\n")
      }
    end
  end

  private

  def escape_url_ja(url)
    ret = "".dup
    url.split(//).each do |c|
      if  /[-_.!~*'()a-zA-Z0-9;\/\?:@&=+$,%#]/ =~ c
        ret.concat(c)
      else
        ret.concat(CGI.escape(c))
      end
    end
    ret
  end
end
