![login](https://github.com/user-attachments/assets/817d4e07-2791-46d1-9c10-8e560c55c6f7)
![create](https://github.com/user-attachments/assets/b2890fe8-4f45-4699-8e57-2ce41e43df05)
![admin](https://github.com/user-attachments/assets/316f2c6c-a0a3-4790-8a60-623b3c759949)
![addpr](https://github.com/user-attachments/assets/6081fc96-8cb0-4a19-8fdf-a0747bd6bb69)
![manager](https://github.com/user-attachments/assets/defa9c7b-ea51-42cd-8160-0faa6ac124c1)
![viewer](https://github.com/user-attachments/assets/f7775672-2ba8-47e4-bd08-d46973cf5692)
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
