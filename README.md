Inventory App
=============

We're going to make a Ruby app from scratch that models a simple inventory system.

INSTALL
=======

* Don't forget to fork, cd into projects, clone this project as per usual.

THE PLAN
========

The application is going to model an inventory system, cataloging various items for a retail outlet. The system will be able to keep track of items, allowing the user to add them to the system, update and remove them, whilst being backed by a file for data storage.

It will be a single user system with no notions of privacy / security (rather like some multi-million dollar systems I won't name).

You can decide whether you'd prefer to use a text-based command line app or a Shoes app and stick with it.

REQUIREMENTS
============

* A retailer adds information about a CD, providing an title, description, artist_name, release_date. Use the provided generate_product_number on the Product class to uniquely identify products.
* A retailer adds information about a Book, providing a title, description, author, genre
* A retailer adds information about a Toy, provding a title, description, age_range
* A retailer sees the stock level for an item
* A retailer sells an item, which reduces the stock level
* A retailer is warned if the stock level falls below 10.
* A retailer is prevented from selling something if the stock level is 0
* A retailer edits information about an individual item.
* A retailer loans an item to a Customer, storing their name, phone_number, email and the product_number of the product loaned. This reduces the stock level by one. Assume that a customer can only loan one product at a time.
* A retailer can see how many products have been loaned.
* A retailer can find products by title
* A retailer finds a product by a partial match of the description.
* A retailer reopens the program and preserves the catalog (saves to a file!)
* The retailer is not fussed about how the program looks + feels (Don't spend ages working on front-end things- make it functional!)

TIPS
====

* Use objects. Where can we use inheritance to avoid re-use?
* Keep your logic in methods, which belong to Classes which are responsible for maintaining that data.
* Implement a save method on the Product class, that knows how to put itself into a data store.

SUBMISSION
==========

Send me a pull request with your work and I'll look over it over the weekend. Bring discussion with you for Monday morning to talk about how you implemented your app and why you decided to make it the way you did.