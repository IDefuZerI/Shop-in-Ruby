module ProductsHelper
  def product_image_or_placeholder(image_path)
    # Check if the image path is blank or if the image file does not exist in the assets
    if image_path.present? && Rails.application.assets.find_asset(image_path).present?
      image_path
    else
      "products/placeholder_image.webp"
    end
  end
end
