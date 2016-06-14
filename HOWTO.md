## How-To...

Q: How can I install all updates on a specific system?

A: Go to /systems and find your desired system, either by using the search function or by filtering or ordering the list otherwise. If there are any updates available on it, there should already be a checkbox on the right side under 'Install?'. Check it and click on 'Update Selected', then confirm the update by clicking on 'Execute Job'.


Q: Quick! How can I install all updates on all systems?

A: Go to the system page (/systems) and click on 'Update All', then confirm the tasks by clicking on 'Execute Job'. There, all done!


Q: I need to install multiple updates on all servers where the software is installed. How would I do that?

A: That's what the Systems/Packages page is for! Visit it (/system_package_relations), find and select the desired packages via the checkbox in the column 'Selected' and click on 'Update Selected'. This will install the updates for this package on all systems where it's available!


Q: I need to install multiple updates on all servers where the software is installed EXCEPT for that one system where I shouldn't touch anything. How would I do that?

A: Visit the Systems/Packages page (/system_package_relations), find and select the desired packages via the checkbox in the column 'Selected' and then display the applicable systems for each update by a click on the arrow. De-select that one system (or multiple ones) and repeat for all packages. Then click on 'Update Selected'. This will install the updates for this package on all selected systems!


Q: How to create a new User?

A: Go to Users, click on "New User" and provide a Name, Email, a role and a password including password confirmation. The password has to be longer than 8 characters.


Q: How to edit a User?

A: You can only do this if your role has the permission to manage users. If that's the case, go to the user page (/users) and click on the user's edit icon (the pencil). You can edit all properties here. Make sure to click on "Save" after you are done with your changes!


Q: How to delete a User?

A: Go to the user page (/users) and click on the user's delete icon (the X). This button only appears if you have the proper permissions. For obvious reasons it's not possible to delete your own user.


Q: How to check a user's permissions / what a user can do?

A: Simple! Go the the user's profile (via /user and a click on the user) and check the permission summary on the right side.


Q: How to create a new Role?

A: Go to the Roles page (/roles), click on "New Role" and provide a Name, Permission level and whether or not this role can manage users, then click on "Save".


Q: How to edit a Role?

A: Go to the role page (/roles) and click on the role's edit icon (the pencil). You can edit all properties here. Make sure to click on "Save" after you are done with your changes!


Q: How to delete a Role?

A: Go to the role page (/roles) and click on the role's delete icon (the X). You can only delete roles when no users are assigned this role!


Q: How to see all users of a certain role?

A: Visit the role's page (via /roles and a click on the role) and check out the list of users on the bottom.


Q: How can I create a System Group?

A: Go to the system group page (/system_groups) and click on "New System Group" on the top right. Give it a name and a permission level and click save. Done!


Q: How can I edit a System Group?

A: Visit the group page (/system_groups), click on the edit button for the desired system group (looks like a pencil). This button only appears when you have the required permissions (i.e. your role's permission level must be higher than the group's)!


Q: How can I create a Package Group?

A: Go to the package group page (/package_groups) and click on "New Package Group" on the top right. Give it a name and a permission level and click save. Done!


Q: How can I edit a Package Group?

A: Visit the group page (/package_groups), click on the edit button for the desired package group (looks like a pencil). This button only appears when you have the required permissions (i.e. your role's permission level must be higher than the group's)!


Q: How can I create a new System?

A: Trick question! Systems can't be created, they register themselves. If you really have to create systems manually, use the console (`rails console` in the app's root directory)


Q: How can I create a new Package?

A: You'll have to install that package on a registered system and wait for an update from the system. Packages can't be created manually.


Q: How can I see which systems haven't contacted the control center in some time?

A: There's handy dashboard entry for that - look for a message like '2 Systems not seen in past 4 hours' in the Systems box. Click on the 'Check' link next to it to go to the systems page and see the 'missing' systems on top.


Q: When I installed the updates by hand, I always saw the log file. I miss that. How can I get the logs?

A: Good news! Each successful or failed tasks returns the output from apt like you would see it when you'd do it manually. To see them, go the /tasks and find your task, then click on 'Task Execution'. If there's nothing, apt didn't return anything or there was a different error and you should probably investigate that system.


Q: How can I log out?

A: Click on 'Logout'.


Q: How can I log in?

A: If you see the menu option "Login", click on it. If you don't see it, you're already logged in.


## Troubleshooting

Q: I accidentally deleted all users!

A: No worries. Start a rails console with `rails console` and enter

```
adminRole = Role.exists?(name: "Admin") ? Role.where(name: "Admin")[0] : Role.create(name: "Admin", permission_level: 9, is_user_manager: true)
User.create( { name: "admin", email: "admin", role: adminRole, password: "myPassword", password_confirmation: "myPassword" } )
```

This will create a new admin user.


Q: How can I reset my password? Asking for a friend.

A: Unfortunately, there's no 'forgot password' function yet. Tell your friend that they should use the console (type `rails console` in app's root folder) to set the password manually by using

```
forgetfulUser = User.where(name: "NAME OF THE USER", email: "EMAIL OF THE USER")[0]
forgetfulUser.password = 'NEW PASSWORD GOES HERE'
forgetfulUser.password_confirmation = 'NEW PASSWORD GOES HERE'
forgetfulUser.save()
```

Now your friend can log in again with the new password!
