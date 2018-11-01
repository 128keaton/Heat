module DeploymentHelper
  def ready_for_deployment(role_quantity)
    if role_quantity.quantity < role_quantity.max_quantity
      '<i class="fas icon-wrapper fa-times  red-icon"><span class="icon-text">Not Ready to Deploy</span></i>'.html_safe
    else
      '<i class="fas icon-wrapper fa-check green-icon"><span class="icon-text">Ready to Deploy</span></i>'.html_safe
    end
  end
end