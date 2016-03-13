# Donate Park Spot

Technical Guide
===============

Overview
--------

The Donate Park Spot app is designing to allow users to find parking easier and to donate money to Charity organizations. Every is able to add a new Spot into the database with a leaving time and a user looking for a parking spot can see it and then the user can bid a donation for that spot.

In order to to developed this system we use a simple Client/Server architecture that will be explained on the next section, followed by the app architecture and the server architecture. To finish, we will get into the details of Languages and technology used on each part of the system

Architecture
------------

The architecture of the system is based on the Client-Server pattern where the app is the client and the Parse Server (more on the Parse server later) is the Server.

###App Architecture

The mobile application has built using Model-View-Controller (MVC) very common for client side of system that have the only intention of doing requests to a server. The app is divide into several different controllers each representing one screen that is shown on the app.

###Server Architecture

The server of our system works similar to a web service that only responds to attempts to update or create a new object into the database. Most functions act as triggers that will be called after a object be created/updated on the database in order to update different objects that for some reason need to be updated. We also run a background job that is responsible for spot that are no longer available for users.

Languages Used
--------------
There are two major languages used on this System. Swift for the app, since it is easier to learn than Objective-C. And JavaScript, the only language accepted by the Parse Server.

Technology Used
---------------

On the Client side all the code was built aiming a release for iPhones with iOS 9 or higher using the most recent version of Xcode (7.2.1). On the server, we used the Parse platform to store our database. 


Developer Guide
===============

Where is the code is?
---------------------
On this repository under the Apache license.

Building and Running the App
----------------------------

The first thing you will need is a Mac computer that will allow you to download Xcode. After Download the DonateParkSpot folder and open the DonateParkSpot.xcodeproj. If everything is set properly you will be able to run it on the iOS simulator.

Deploying the Server
--------------------

Until January 28th 2017, Parse will be available so you can download everything on the Server folder of the GitHub repository and deploy it using Parse tools. The procedure is very simple and you can follow it using this Quickstart (https://www.parse.com/apps/quickstart?app_id=podosphere#cloud_code/unix) for Unix machines. 

However, you can use Parse on your own server by following these documentation files provide by parse:
 https://github.com/ParsePlatform/parse-server

