module DeploymentHelper
  def ready_for_deployment(role_quantity)
    if role_quantity.quantity < role_quantity.max_quantity
      '<i class="ic close red-icon"></i>'.html_safe
    else
      '<i class="fa fa-check"></i>'.html_safe
    end
  end
end