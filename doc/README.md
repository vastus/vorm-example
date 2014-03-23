# Vorm &mdash; A discussion forum

## Introduction

Vorm is a discussion forum platform where registered users can post topics
under various categories and other users can reply to those topics.

Guest users are able to read replies to topics, once they have registered they
can manage topics, and replies they own. Registered users are also able to
search for topics by different search terms.

Admins manage everything; that is users, categories, topics, and replies.

## Implementation

The web app is implemented in ruby and a small web framework called
[sinatra][sinatra]. The database used in this project is MySQL. 

[sinatra]: http://sinatrarb.com/

## Overview

### Use case diagram

![Use case diagram][uc]

[uc]: http://yuml.me/349ff6da.png "Use case diagram"

### Roles and use cases

Guests

> Guests are everybody who aren't signed in. Guest users can only read replies
> to topics.

Users

> Users can create, update, and delete topics and replies they have made. Users
> can search for topics and messages by a search criteria.

Admins

> Admins create, update, and delete users, categories, topics, and replies.

## UI design

The goal is to keep the UI clean and simple w/o any clutter. When the guest
user is presented the index page of the app, categories are shown and links
for registering and logging in. All users can browse categories and view
topics and replies. Logged in users have a profile page for simple editing of
their information (such as email, password). Logged in users are shown links
for new topic and reply also to edit and remove. Admins have links for
handling categories.

![UI][ui-thumb]

First draft of the UI.

### Static demo

Check out the [static demo][static-demo] for initial UI.

[ui-thumb]: img/ui-thumb.jpeg "UI"
[static-demo]: http://juhotaha.users.cs.helsinki.fi/vorm/demo/index.html "Static demo"

