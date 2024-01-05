# frozen_string_literal: true

require 'open-uri'

class Secure::RecipesController < Secure::ApplicationController
  def index

  end

  def preview
    url = params[:url]

    og_title = nil
    og_image_url = nil

    uri = URI.open(escape_url_ja(url))

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

    render json: {
      statue: "success",
      og_title: og_title,
      og_image_url: og_image_url
    }
  end

  def create
    recipe = Recipe.new(
      user_account_id: @current_user.id,
      title: params[:title],
      url: params[:url],
      registered_at: Time.current
    )

    image_url = params[:image_url]
    image_io = URI.open(escape_url_ja(image_url))
    image_filename = "image.#{image_io.content_type.split('/').last}"

    recipe.image.attach(io: image_io, filename: image_filename, content_type: image_io.content_type)

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
