# -*- encoding : utf-8 -*-
module DomainsHelper
  def tempalte_names
    Template.all.map { |t| t.name }
  end
end
