---
lang: en
layout: article_with_sidebar
updated_at: '2016-07-26 15:55 +0400'
order: 100
published: true
title: Model editing
identifier: ref_8MoO0Ob
---

This article describes new way to create form to edit model entity. Original article with old implementation: {% link "Model editing page" ref_LanG54L9 %}

## Implementation

We start with creating a simple module with developer ID **XCExample** and module ID **ModelEditing**. Then, we create a page target=example_product_edit in admin area. For that we create:

*   an empty controller class `\XLite\Module\XCExample\ModelEditing\Controller\Admin\ExampleProductEdit`;
*   page widget class `\XLite\Module\XCExample\ModelEditing\View\Page\Admin\ProductEdit` with the following content: 

    {% raw %}```php
    <?php
    // vim: set ts=4 sw=4 sts=4 et:

    /**
     * Copyright (c) 2011-present Qualiteam software Ltd. All rights reserved.
     * See https://www.x-cart.com/license-agreement.html for license details.
     */

    namespace XLite\Module\XCExample\ModelEditing\View\Page\Admin;

    /**
     * Product edit page view
     *
     * @ListChild (list="admin.center", zone="admin")
     */
    class ProductEdit extends \XLite\View\AView
    {
        /**
         * Return list of allowed targets
         *
         * @return array
         */
        public static function getAllowedTargets()
        {
            return array_merge(parent::getAllowedTargets(), array('example_product_edit'));
        }

        /**
         * Return widget default template
         *
         * @return string
         */
        protected function getDefaultTemplate()
        {
            return 'modules/XCExample/ModelEditing/page/product_edit/body.twig';
        }
    }
    ```{% endraw %}

*   an empty page template `<X-Cart>/skins/admin/modules/XCExample/ModelEditing/page/product_edit/body.twig`.

Now we start creating a widget for model editing. For that we create the `<X-Cart>classes/XLite/Module/XCExample/ModelEditing/View/FormModel/ExampleProductEdit.php` file with the following code: 
    
{% raw %}```php
<?php
// vim: set ts=4 sw=4 sts=4 et:

/**
 + Copyright (c) 2011-present Qualiteam software Ltd. All rights reserved.
 + See https://www.x-cart.com/license-agreement.html for license details.
 */

namespace XLite\Module\XCExample\ModelEditing\View\FormModel;

class ExampleProductEdit extends \XLite\View\FormModel\AFormModel
{
    /**
     + Do not render form_start and form_end in null returned
     *
     + @return string|null
     */
    protected function getTarget()
    {
        return 'example_product_edit';
    }

    /**
     + @return string
     */
    protected function getAction()
    {
        return 'update';
    }

    /**
     + @return array
     */
    protected function getActionParams()
    {
        $identity = $this->getDataObject()->default->identity;

        return $identity ? ['product_id' => $identity] : [];
    }

    /**
     + @return array
     */
    protected function defineFields()
    {
        $skuMaxLength = \XLite\Core\Database::getRepo('XLite\Model\Product')->getFieldInfo('sku', 'length');
        $nameMaxLength = 255;

        $currency = \XLite::getInstance()->getCurrency();
        $currencySymbol = $currency->getCurrencySymbol(false);


        $schema = [
            self::SECTION_DEFAULT => [
                'sku'         => [
                    'label'       => static::t('SKU'),
                    'constraints' => [
                        'XLite\Core\Validator\Constraints\MaxLength' => [
                            'length'  => $skuMaxLength,
                            'message' =>
                                static::t('SKU length must be less then {{length}}', ['length' => $skuMaxLength]),
                        ],
                    ],
                    'position'    => 100,
                ],
                'name'        => [
                    'label'       => static::t('Product name'),
                    'required'    => true,
                    'constraints' => [
                        'Symfony\Component\Validator\Constraints\NotBlank' => [
                            'message' => static::t('This field is required'),
                        ],
                        'XLite\Core\Validator\Constraints\MaxLength'       => [
                            'length'  => $nameMaxLength,
                            'message' =>
                                static::t('Name length must be less then {{length}}', ['length' => $nameMaxLength]),
                        ],
                    ],
                    'position'    => 200,
                ],
                'price'       => [
                    'label'       => static::t('Price'),
                    'type'        => 'XLite\View\FormModel\Type\SymbolType',
                    'symbol'      => $currencySymbol,
                    'pattern'     => [
                        'alias'          => 'currency',
                        'prefix'         => '',
                        'rightAlign'     => false,
                        'groupSeparator' => $currency->getThousandDelimiter(),
                        'radixPoint'     => $currency->getDecimalDelimiter(),
                        'digits'         => $currency->getE(),
                    ],
                    'constraints' => [
                        'Symfony\Component\Validator\Constraints\GreaterThanOrEqual' => [
                            'value'   => 0,
                            'message' => static::t('Minimum value is X', ['value' => 0]),
                        ],
                    ],
                    'position'    => 300,
                ],
                'full_description' => [
                    'label'    => static::t('Description'),
                    'type'     => 'XLite\View\FormModel\Type\TextareaAdvancedType',
                    'position' => 400,
                ],
            ],
        ];

        return $schema;
    }
}
```{% endraw %}

Let us have a closer look at this implementation:
1.  Our class extends an abstract implementation model editing widget (`\XLite\View\FormModel\AFormModel`):
    {% raw %}```php
    class ExampleProductEdit extends \XLite\View\FormModel\AFormModel
    {...}
    ```{% endraw %}
2.  Next we implement methods to configure form action: (`getTarget`, `getAction`, `getActionParams`). This needs to submit form to appropriate controller and action with correct parameters.
3.  After that, we define what fields will be displayed in this widget by implementing method `defineFields()`:
    {% raw %}```php
    /**
     * @return array
     */
    protected function defineFields()
    {
        $skuMaxLength = \XLite\Core\Database::getRepo('XLite\Model\Product')->getFieldInfo('sku', 'length');
        $nameMaxLength = 255;

        $currency = \XLite::getInstance()->getCurrency();
        $currencySymbol = $currency->getCurrencySymbol(false);


        $schema = [
            self::SECTION_DEFAULT => [
                'sku'         => [
                    'label'       => static::t('SKU'),
                    'constraints' => [
                        'XLite\Core\Validator\Constraints\MaxLength' => [
                            'length'  => $skuMaxLength,
                            'message' =>
                                static::t('SKU length must be less then {{length}}', ['length' => $skuMaxLength]),
                        ],
                    ],
                    'position'    => 100,
                ],
                'name'        => [
                    'label'       => static::t('Product name'),
                    'required'    => true,
                    'constraints' => [
                        'Symfony\Component\Validator\Constraints\NotBlank' => [
                            'message' => static::t('This field is required'),
                        ],
                        'XLite\Core\Validator\Constraints\MaxLength'       => [
                            'length'  => $nameMaxLength,
                            'message' =>
                                static::t('Name length must be less then {{length}}', ['length' => $nameMaxLength]),
                        ],
                    ],
                    'position'    => 200,
                ],
                'price'       => [
                    'label'       => static::t('Price'),
                    'type'        => 'XLite\View\FormModel\Type\SymbolType',
                    'symbol'      => $currencySymbol,
                    'pattern'     => [
                        'alias'          => 'currency',
                        'prefix'         => '',
                        'rightAlign'     => false,
                        'groupSeparator' => $currency->getThousandDelimiter(),
                        'radixPoint'     => $currency->getDecimalDelimiter(),
                        'digits'         => $currency->getE(),
                    ],
                    'constraints' => [
                        'Symfony\Component\Validator\Constraints\GreaterThanOrEqual' => [
                            'value'   => 0,
                            'message' => static::t('Minimum value is X', ['value' => 0]),
                        ],
                    ],
                    'position'    => 300,
                ],
                'full_description' => [
                    'label'    => static::t('Description'),
                    'type'     => 'XLite\View\FormModel\Type\TextareaAdvancedType',
                    'position' => 400,
                ],
            ],
        ];

        return $schema;
    }
    ```{% endraw %}

The form must contain at least one section (`self::SECTION_DEFAULT` section is defined by default) so in this method we return an array: **key** of its elements is a **name** of the section and **value** is the array of section fields. Each **key** of section fields is the name of the field. In our case, they are **sku**, **name**, **price** and **full_description**. The value of array's elements is an array of parameters that define each field.

Параметры поля должны соответсвовать опциям выбранного типа (тип задается полем **type** в параметрах поля, если тип не задан используется `Symfony\Component\Form\Extension\Core\Type\TextType`), исключение: параметроы **type** и **position** - эти параметры не используются внутри типов.

Now we need to create the `\XLite\Module\XCExample\ModelEditing\Model\DTO\ExampleProductEdit` it need to validate data and trasfer data to and from form. For that, we create the
`<X-Cart>/classes/XLite/Module/XCExample/ModelEditing/Model/DTO/ExampleProductEdit.php` file with the following content: 
{% raw %}```php
<?php
// vim: set ts=4 sw=4 sts=4 et:

/**
 * Copyright (c) 2011-present Qualiteam software Ltd. All rights reserved.
 * See https://www.x-cart.com/license-agreement.html for license details.
 */

namespace XLite\Module\XCExample\ModelEditing\Model\DTO;

use Symfony\Component\Validator\Context\ExecutionContextInterface;
use XLite\Core\Translation;
use XLite\Model\DTO\Base\CommonCell;

class ExampleProductEdit extends \XLite\Model\DTO\Base\ADTO
{
    /**
     * @param ExampleProductEdit        $dto
     * @param ExecutionContextInterface $context
     */
    public static function validate($dto, ExecutionContextInterface $context)
    {
        if ($dto->default->sku && !static::isSKUValid($dto)) {
            static::addViolation($context, 'default.sku', Translation::lbl('SKU must be unique'));
        }
    }

    /**
     * @param ExampleProductEdit $dto
     *
     * @return boolean
     */
    protected static function isSKUValid($dto)
    {
        $sku = $dto->default->sku;
        $identity = $dto->default->identity;

        /** @var \XLite\Model\Product $entity */
        $entity = \XLite\Core\Database::getRepo('XLite\Model\Product')->findOneBySku($sku);

        return !$entity || (int) $entity->getProductId() === (int) $identity;
    }

    /**
     * @param mixed|\XLite\Model\Product $object
     */
    protected function init($object)
    {
        $default = [
            'identity' => $object->getProductId(),

            'sku'              => $object->getSku(),
            'name'             => $object->getName(),
            'price'            => $object->getPrice(),
            'full_description' => $object->getDescription(),
        ];

        $this->default = new CommonCell($default);
    }

    /**
     * @param \XLite\Model\Product $object
     * @param array|null           $rawData
     *
     * @return mixed
     */
    public function populateTo($object, $rawData = null)
    {
        $default = $this->default;

        $object->setSku(trim($default->sku));
        $object->setName((string) $default->name);
        $object->setPrice($default->price);
        $object->setDescription((string) $default->full_description);
    }
}
```{% endraw %}

*   `static::validate()` method need to implement DTO leavel validation (for field level validation `constraint` field param used)
*   `init()` method used to transfer data to DTO
*   `populateTo` method used to transfer data from DTO

Now we are good with the model editing widget and we need to add it to the page template. We go to the `<X-Cart>/skins/admin/modules/XCExample/ModelEditing/page/product_edit/body.twig` template and define its content as follows: 
{% raw %}```twig
{{ widget('\\XLite\\Module\\XCExample\\ModelEditing\\View\\FormModel\\ExampleProductEdit') }}
```{% endraw %}

Finally, we have to adjust our `\XLite\Module\XCExample\ModelEditing\Controller\Admin\ExampleProductEdit` controller class in order to process requests about saving product model – implement aforementioned `doActionUpdate()` method. We go to the `<X-Cart>/classes/XLite/Module/XCExample/ModelEditing/Controller/Admin/ExampleProductEdit.php` file and define its content as follows:

{% raw %}```php
<?php
// vim: set ts=4 sw=4 sts=4 et:

/**
 * Copyright (c) 2011-present Qualiteam software Ltd. All rights reserved.
 * See https://www.x-cart.com/license-agreement.html for license details.
 */

namespace XLite\Module\XCExample\ModelEditing\Controller\Admin;

/**
 * Product edit controller
 */
class ExampleProductEdit extends \XLite\Controller\Admin\AAdmin
{
    use \XLite\Controller\Features\FormModelControllerTrait;

    /**
     * @var array
     */
    protected $params = array('target', 'product_id');

    /**
     * @var \XLite\Model\Product
     */
    protected $product;

    /**
     * @return integer
     */
    public function getProductId()
    {
        return (int) \XLite\Core\Request::getInstance()->product_id ?: 0;
    }

    /**
     * @return \XLite\Model\Product
     */
    public function getProduct()
    {
        if (null === $this->product) {
            $product = \XLite\Core\Database::getRepo('\XLite\Model\Product')->find($this->getProductId());
            $this->product = $product ?: new \XLite\Model\Product();
        }

        return $this->product;
    }

    /**
     * @return \XLite\Model\DTO\Base\ADTO
     */
    public function getFormModelObject()
    {
        return new \XLite\Module\XCExample\ModelEditing\Model\DTO\ExampleProductEdit($this->getProduct());
    }

    protected function doActionUpdate()
    {
        $dto = $this->getFormModelObject();
        $product = $this->getProduct();

        $formModel = new \XLite\Module\XCExample\ModelEditing\View\FormModel\ExampleProductEdit(['object' => $dto]);
        $form = $formModel->getForm();

        $data = \XLite\Core\Request::getInstance()->getData();
        $rawData = \XLite\Core\Request::getInstance()->getNonFilteredData();

        $form->submit($data[$this->formName]);

        if ($form->isValid()) {
            $dto->populateTo($product, $rawData[$this->formName]);
            \XLite\Core\Database::getEM()->persist($product);
            \XLite\Core\Database::getEM()->flush();

        } else {
            $this->saveFormModelTmpData($rawData[$this->formName]);
        }

        $productId = $product->getProductId() ?: $this->getProductId();

        $params = $productId ? ['product_id' => $productId] : [];

        $this->setReturnURL($this->buildURL('example_product_edit', '', $params));
    }
}
```{% endraw %}

We define $params property as: 
{% raw %}```php
protected $params = array('target', 'product_id');
```{% endraw %}
and it will tell controller class that only **target** and **product_id** parameters can be accepted.
*   `getFormModelObject()` method should return the DTO.
*   `doActionUpdate()` method defines a routine that will be run after we submit a form with the model editing widget values. The main processing happens in this lines:
    {% raw %}```php
    $form->submit($data[$this->formName]);

    if ($form->isValid()) {
        $dto->populateTo($product, $rawData[$this->formName]);
        \XLite\Core\Database::getEM()->persist($product);
        \XLite\Core\Database::getEM()->flush();

    } else {
        $this->saveFormModelTmpData($rawData[$this->formName]);
    }
    ```{% endraw %}
`$form->submit(...)` - move data from request to DTO and validate it
`$dto->populateTo(...)` - move data from DTO to Entity
`$this->saveFormModelTmpData(...)` - saves data to session if error occured. It will be used when form with unsewed data and error will be shown.

Also, if we create a new product, we need to properly redirect merchant to this newly created product page, that is why we pull new product id – `$productId = $product->getProductId() ?: $this->getProductId();` – and redirect customer as follows: 

{% raw %}```php
$params = $productId ? ['product_id' => $productId] : [];
$this->setReturnURL($this->buildURL('example_product_edit', '', $params));
```{% endraw %}

We are done with this mod and now we have to re-deploy the store. After that try to open the admin.php?target=example_product_edit page.

## Module pack
`XCExample\ModelEditing`