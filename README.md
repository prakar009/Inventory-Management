Inventory Management Admin App
Overview

This is a Flutter-based inventory management application built using Firebase and BLoC. The app allows users to manage products, track stock levels, and view basic analytics through a dashboard.

It supports role-based access so different users have different permissions inside the app.

Features
Authentication

Login and Register using Firebase Authentication

Users are assigned roles (Admin, Manager, Viewer)




Product Management

Add new products

Update existing products

Delete products

View product list


Stock Tracking

Out of Stock (0 items)

Low Stock (less than 10 items)

In Stock

Role-Based Access

Admin → Full access (add, edit, delete)

Manager → Can update stock only

Viewer → Can only view products

Dashboard

Total number of products

Low stock count

Total inventory value

Additional Features

Infinite scrolling (pagination)

Search products

Filter products (All / Low / Out of Stock)

Reusable UI components