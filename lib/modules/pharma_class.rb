module PharmaClass

  def drugs_in_class
    # grab drug detail for classmates
    Drug.canonical.where(product_ndc:ndcs_in_class)
      .select(:product_ndc,:proprietary_name,:nonproprietary_name)
  end

  def ndcs_in_class
    # find all NDCs for same class_name, expect myself
    self.class
      .where(class_name:class_name)
      .map{|e|e.product_ndc}
      .delete_if{|e|e==product_ndc}
  end

end