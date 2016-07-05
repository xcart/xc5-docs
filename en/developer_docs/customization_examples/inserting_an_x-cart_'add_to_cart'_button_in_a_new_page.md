---
layout: article_with_sidebar
lang: en
title: 'Inserting an X-Cart &#39;Add to cart&#39; button in a new page'
categories: [developer_docs]
---

{% include global.html %}

Sometimes the standard 'Add to cart' buttons you get in your X-Cart  store are not enough, and you want to add another 'Add to cart' button - for example, on a static page inside your X-Cart store, or on a product landing page outside X-Cart.

There are two methods to do so:

*   [Method 1]({{ baseurl_lang }}/developer_docs/customization_examples/inserting_an_x-cart_'add_to_cart'_button_in_a_new_page.html) (can be used both for pages outside and inside X-Cart);
*   [Method 2](9666687.html) (can be used only inside X-Cart).

# Method 1

1.  In the file `etc/config.php`, add the line

    {% highlight php %}HTML.Trusted = On{% endhighlight %}

    right after the line 

    {% highlight php %}[html_purifier]{% endhighlight %}

    This line is needed to ensure that X-Cart will _not_ strip certain tags - like the tag <buttob> - from code.

2.  Add the following code to the page where you need to insert your 'Add to cart' button:

    {% highlight php %}<form action="?target=cart" method="post" accept-charset="utf-8" class="custom-add2cart">
       <input type="hidden" name="target" value="cart" />
       <input type="hidden" name="action" value="add" />
       <input type="hidden" name="product_id" value="5" />
       <div class="add-button-wrapper widget-fingerprint-product-add-button">
           <button type="submit" class="btn regular-button regular-main-button add2cart submit">
               <span>Add to cart</span>
           </button>
       </div>
    </form>{% endhighlight %}

    where:

    **5** is the id of the product that needs to be added to cart; for example, for the product [http://demostore.x-cart.com/admin/admin.php?target=product&product_id=37](http://demostore.x-cart.com/admin/admin.php?target=product&product_id=37) this id is **37**.

    **?target=cart** is the address of the cart page on the store site. If the code to insert the 'Add to cart' button is located on another domain, it is necessary to specify the full URL; for example, [http://demostore.x-cart.com/?target=cart](http://demostore.x-cart.com/?target=cart).

# Method 2

This method can be used to create a button that will add a product to cart without reloading the page:

1.  In the file `etc/config.php`, add the line

    {% highlight php %}HTML.Trusted = On{% endhighlight %}

    right after the line 

    {% highlight php %}[html_purifier]{% endhighlight %}

    This line is needed to ensure that X-Cart will _not_ strip certain tags - like the tag <buttob> - from code.

2.  Add the following code to the page where you need to insert your 'Add to cart' button:

    {% highlight php %}<script type="text/javascript">
       window.onload = function () {
           $('form.custom-add2cart').each(function () {
               var form = $(this).get(0);
               if (form) {
                   form.commonController.enableBackgroundSubmit()
               }
           })
       };
    </script>{% endhighlight %}

Please note that this method will not work for X-Cart static pages in stores using the module TinyMCE integration, because this module will strip <script> from code. Also note that this method will not work for pages located on other sites outside X-Cart.