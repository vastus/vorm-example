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

