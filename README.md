# Discourse Notifier
The discourse-notifier tries to increase user engagement by sending notifications for the most relevant topics based on his previous reads. The site users have a choice to use this setting or not, by default it remains off.

# About
This plugin enables the site admin to control the notification level of its users based on frequently visited categories and tags.

# Features
Select Cron Pattern:- The cron task can be scheduled by this field providing options like minutes, hours, weeks, months, years.

Select Cron Pattern Value:- This field specifies the number/Value for the pattern selected in the above field.

Discourse Notifier select n week data:- This field decides how many previous week's data to be considered.

Discourse Notifier top n categories:- This field decides the number of categories from the top categories of the user’s most viewed topics.

Discourse Notifier top n tags:- The input in this field decides the top tags that will influence the notifications similar to categories.

Discourse Notifier set category notification level:- The admin can decide the level of notifications based on categories.

Discourse Notifier set tag notification level:- Similar to the categories, the site admin can also set the level of notification for tags.

# Notification Level Options 
Muted : 0
Normal: 1
Tracking: 2
Watching: 3

# Example
Cron Pattern:- minute
Cron Pattern Value:- 5
Select n weeks data:- 10
Top n categories:- 3
Top n tags:- 3
Category Notification Level:- Watching 
Tags Notification Level:- Watching

Every 5 minutes the plugin will repeat and the top 3 categories and 3 tags will be revised considering last 10 week’s activities and notification level will change to watching

# Note
All the fields are named with a prefix “discourse notifier” to make it easy for the admin to search them in the settings

The plugin provides a setting through which a site user can refuse to change its notification level. The site users have a choice to use this setting or not, by default it remains off.

The setting is provided at /preferences/profile section named as Allow site to change your notification level of frequently visited categories and Allow site to change your notification level of frequently visited tags

As per the discussion response, I will change the category setting to preferences/categories location and tag setting to preferences/tags location.
