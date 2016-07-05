---
layout: article_with_sidebar
lang: en
title: 'Adding new property to a product'
categories: [developer_docs]
---

{% include global.html %}

# Introduction

This guide teaches X-Cart developers how they can add their own field to products and then use it on invoices.

# Table of Contents

*   [Introduction](#introduction)
*   [Table of Contents](#table-of-contents)
*   [Implementation](#implementation)
    *   [Adding new field to product model](#adding-new-field-to-product-model)
    *   [Creating interface for editing this field](#creating-interface-for-editing-this-field)
    *   [Showing this field value on thank you page](#showing-this-field-value-on-thank-you-page)
    *   [Checking the results](#checking-the-results)
*   [Module pack](#module-pack)

# Implementation

First of all, [create a new module]({{ baseurl_lang }}/developer_docs/getting_started/step_1_-_creating_simplest_module.html). We are creating a module with developer ID **Tony** and module ID **ProductFieldDemo**.

## Adding new field to product model

[Decorate]({{ baseurl_lang }}/developer_docs/getting_started/step_3_-_applying_logic_changes.html) the `\XLite\Model\Product` class ([more info about X-Cart classnames]({{ baseurl_lang }}/developer_docs/misc/x-cart_classes_structure_and_namespaces.html)). We are creating the `<X-Cart>/classes/XLite/Module/Tony/ProductFieldDemo/Model/Product.php` file with the following content: 

{% highlight php %}<?php
// vim: set ts=4 sw=4 sts=4 et:

namespace XLite\Module\Tony\ProductFieldDemo\Model;

class Product extends \XLite\Model\Product implements \XLite\Base\IDecorator
{
	/**
	 * @Column (type="string", length=32)
	 */
	protected $testField;
}{% endhighlight %}

*   `protected $testField` says that now product objects will have a new property that can be accessed like `$product->testField`
*   this piece of code 

    {% highlight php %}	/**
    	 * @Column (type="string", length=32)
    	 */{% endhighlight %}

    specifies parameters of this field, i.e. that this field is a **string** and can be up to **32 symbols**.

That is it. If we re-deploy the store right now, X-Cart will create a new field in the database according to our parameters we specified. Do not initiate store re-deployment right now though.

## Creating interface for editing this field

Now we need to be able to specify value of this property on product details page in admin area. We decorate `\XLite\View\Model\Product` class and create  
`<X-Cart>/classes/XLite/Module/Tony/ProductFieldDemo/View/Model/Product.php` file with the following content: 

{% highlight php %}<?php
// vim: set ts=4 sw=4 sts=4 et:

namespace XLite\Module\Tony\ProductFieldDemo\View\Model;

class Product extends \XLite\View\Model\Product implements \XLite\Base\IDecorator
{
	public function __construct(array $params = array(), array $sections = array())
    {
        parent::__construct($params, $sections);

        $this->schemaDefault += array (
        	'testField' => array(
            	self::SCHEMA_CLASS    => 'XLite\View\FormField\Input\Text',
            	self::SCHEMA_LABEL    => 'Test field',
            	self::SCHEMA_REQUIRED => false,
            	),
        	);
    }
}{% endhighlight %}

Such code will add a new field to the product details page in admin area. This field will be named **Test field **and its value will be saved into `testField` field of `xc_products` MySQL table. The [FormField class]({{ baseurl_lang }}/developer_docs/getting_started/step_4_-_working_with_settings/creating_custom_setting_class.html) that defines an input field in the interface is default `\XLite\View\FormField\Input\Text` one.

_Note: see an example of creating model editing form with more detailed explanation here: [Model editing page]({{ baseurl_lang }}/developer_docs/basics/model_editing_page.html)._

## Showing this field value on thank you page

Finally, we need to display the value of this field on thank you page after the order is placed. It should be displayed like this:![]({{ site.baseurl }}/attachments/8225149/8356106.png)

In order to achieve it, we create the `<X-Cart>/skins/default/en/modules/Tony/ProductFieldDemo/item.test-field.tpl` template with the following content: 

{% highlight php %}{* vim: set ts=2 sw=2 sts=2 et: *}
{**
 * @ListChild (list="invoice.item.name", weight="20")
 *}
<li class="test-field">
  <span class="name">{t(#Test field#)}</span>
  <span class="test-field-value">{item.product.getTestField()}</span>
</li>{% endhighlight %}

In this template, we tell template to be registered in the `invoice.item.name` view list (more about [template system in X-Cart]({{ baseurl_lang }}/developer_docs/getting_started/step_2_-_applying_design_changes.html)).

Another important part is that we just call value of **testField** property as `item.product.getTestField()`, even though we did not declare `getTestField()` method in the `\XLite\Model\Product`. X-Cart creates `get{PropertyName}()` methods for each property automatically, if it is not declared explicitly.

## Checking the results

Now we need to re-deploy the store and after it is finished, we go to any product in admin area and we will be able to see our new field there: ![]({{ site.baseurl }}/attachments/8225149/8356107.png)

Define it as you wish, then add this product to cart in customer zone and place an order with it. You will see a thank you page with this field's value there:![]({{ site.baseurl }}/attachments/8225149/8356108.png)

# Module pack

You can download this module from here: [https://dl.dropboxusercontent.com/u/23858825/Tony-ProductFieldDemo-v5_1_0.tar](https://dl.dropboxusercontent.com/u/23858825/Tony-ProductFieldDemo-v5_1_0.tar)

## Attachments:

![](images/icons/bullet_blue.gif) [new-field-on-invoice.png]({{ site.baseurl }}/attachments/8225149/8356106.png) (image/png)  
![](images/icons/bullet_blue.gif) [product-details-custom-field.png]({{ site.baseurl }}/attachments/8225149/8356107.png) (image/png)  
![](images/icons/bullet_blue.gif) [thank-you-page-with-custom-product-field.png]({{ site.baseurl }}/attachments/8225149/8356108.png) (image/png)