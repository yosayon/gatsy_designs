class LineItemsController < ApplicationController
 before_action :find_session_user, :only => [:create, :update, :destroy]
 
 def create
  @product = Product.find_by_id(params[:product_id])
   if current_order.product_ids.include?(@product.id)
    line_item = LineItem.find_by(:order_id => current_order.id, :product_id => @product.id)
    line_item.add_quantity
    redirect_to user_cart_path(session_user, current_cart)
   else
    line_item = LineItem.create(:product_id => @product.id, :cart_id => current_cart.id, :order_id => current_order.id, :quantity => 1)
    redirect_to user_cart_path(session_user, current_cart)
   end
 end
 
 def update
  @line_item = LineItem.find(params[:id])
  @line_item.subtract_quantity
  if @line_item.quantity == 0
   current_cart.line_items.destroy(@line_item)
  end
  redirect_to user_cart_path(session_user, current_cart)
 end
 
 def destroy
  product = Product.find_by_id(params[:product_id])
  line_item = LineItem.find(params[:id])
  product.line_items.destroy(line_item)
  redirect_to user_cart_path(session_user, current_cart)
 end
 
 private
 
 def line_item_params
  params.require(:line_item).permit(:product_id, :cart_id, :quantity)
 end
 
end
