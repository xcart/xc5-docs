---
layout: article_with_sidebar
lang: en
title: 'X-Cart classes structure and namespaces'
categories: [developer_docs]
---

{% include global.html %}

# Introduction

This article describes the structure of X-Cart classes. Also, it describes how to generate namespaces correctly.

# Table of Contents

*   [Introduction](#introduction)
*   [Table of Contents](#table-of-contents)
*   [X-Cart classes](#x-cart-classes)
*   [Generating namespaces](#generating-namespaces)

# X-Cart classes

All X-Cart classes are located in the `<X-Cart>/classes/` directory. Let us walk through each type of X-Cart classes:

*   `<X-Cart>/classes/XLite.php` is the class of the whole application; you will never use it in new modules;
*   `<X-Cart>/classes/Base/` directory contains definitions of basic X-Cart interfaces including **Decorator** interface that allows [applying changes to every part of X-Cart store]({{ baseurl_lang }}/../getting_started/step_3_-_applying_logic_changes.md) without modifying core classes;
*   `<X-Cart>/classes/Controller/` directory contains definitions of classes that **handle requests** to X-Cart (controllers). Check [general X-Cart workflow](Step-3---applying-logic-changes_8224804.html#Step3-applyinglogicchanges-GeneralX-Cartworkflow) article in order to learn more about controller classes;
*   `<X-Cart>/classes/Core/` directory contains definitions of core X-Cart entities, such as database, HTTP request, Mailer etc;
*   `<X-Cart>/classes/DataSet/` directory includes the classes that defines different data structures; they are seldom used in the modules;
*   `<X-Cart>/classes/Logic/` folder contains the classes that describe the business logic of complex routines: order calculation, import/export, etc;
*   `<X-Cart>/classes/Model/` directory includes the classes that describe different X-Cart entities, such as products, orders, users, shipping and payment methods, menus etc;
*   `<X-Cart>/classes/Module/` folder contains files added by modules (default and 3rd party ones); if you [write the module]({{ baseurl_lang }}/../getting_started/step_1_-_creating_simplest_module.md), you will put your files into this folder only; all module files (except templates) are stored in the `<X-Cart>/classes/Module/<developer-ID>/<module-ID>` directories;
*   `<X-Cart>/classes/Upgrade/` directory contains classes that are used during upgrade procedure;
*   `<X-Cart>/classes/View/` folder contains classes that manage X-Cart's output.

# Generating namespaces

[Namespaces](http://php.net/manual/en/language.namespaces.php) are widely used constructions in OOP languages (PHP in particular). They allow to save time and not mix up different classes with the same name.

Namespace notation in X-Cart is straight-forward: it repeats the class' sub-path of the .php file in the `<X-Cart>/classes/` directory.

*   PHP class defined in the `<X-Cart>/classes/XLite/Controller/Customer/Product.php` file will have namespace` XLite\Controller\Customer`; i.e. namespace includes all names of folders after <X-Cart>/classes/ separated by backslash (**\**)
*   The same way, PHP class defined in the `<X-Cart>/classes/XLite/View/Header.php` file will have namespace `XLite\View`;
*   Namespace can be quite long, e.g. if the class is located in the `<X-Cart>/classes/XLite/Module/CDev/AustraliaPost/Model/Shipping/Processor/AustraliaPost.php` file, then its namespace will be `XLite\Module\CDev\AustraliaPost\Model\Shipping\Processor`;
*   PHP class defined in the `<X-Cart>/classes/XLite.php` file will have no namespace.

_Important note: if you have PHP class **MyClass**, it must be placed into the **MyClass.php** file. Name of the class must be the same as the name of the .php file it contains._