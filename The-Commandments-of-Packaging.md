The Commandments of Packaging


1 Do not assume that your package will be installed interactively via the GUI or on the currently booted volume.

This rule encompasses the core of my argument above; some of the better (and finer) points were:
	•	Do not use tools like sw_vers as conditional tests in your pre/post-install scripts - they only check the currently booted operating system.
	•	DO check that your pre/post-install scripts work on paths with spaces in them.
	•	DO reference files on the target volume by using $3 (in bash) rather than using absolute file references.  Even if you only plan on "allowing" this package to be run on the boot volume, people will want to use this in other workflows.
	•	DO check that your package works from the command line with the following conditions: when a user is logged in, when no-one is logged in, and when installing to a non-boot volume.

2 Unnecessary actions are unnecessary.

If that sounds a little redundant, try installing a package that opens a browser window to the installed-software's homepage.  Some packages also do "helpful" things like using osascript to open a finder window showing their newly-installed Application.  The problem with this is that if you install this package at the loginwindow, then a Finder window (opened by root, no less) is spawned behind the loginwindow.  Someone logging in right after the package is installed now has a finder window with root permissions.  Also, with regard to unloading kext files, Karl Kuehn has a great piece of advice, "If you need to do something like unload/load a kext, then you might want to pay attention to whether you are actually installing on the boot volume or not. This can be done by looking to see if the target volume ($3 in bash) is "/" or not. If it is not, then you don't want to go playing with kext-commands. You probably also want to check for the COMMAND_LINE_INSTALL variable, as this means that the user is probably not aware that something is going on. A complicating factor is that InstaDMG will in some cases wrap thing in a chroot jail, so the test for target volume is not always completely accurate (but we do set the COMMAND_LINE_INSTALL flag)."  Similar suggestions of this nature were as follows:
	•	Do not require unnecessary reboots if you can accomplish the same thing by loading/unloading kext files or restarting services.  
	•	Do not automatically add files to the Dock, Desktop, or anywhere short of /Applications or required directories.
	•	Don't use osascript (or other methods) to open Finder windows.  See this article --> http://blog.macadmincorner.com/adobe-flash-10-installer-launches-finder-as-root/  ***Note that as of 10.5 and higher, I'm told that this bug no longer applies.  The rule is still important, however, for packages installed from the command line or into a Disk Image (a la InstaDMG).
	•	This could have warranted another rule entirely:  DO NOT install unnecessary third party plugins/software/system preferences/helper files without warning!  Yes, Growl is nice, but if you're using it only to remind us about registration and creating an online ID, then give us the chance to opt-out of its inclusion!
	•	Do not ask for admin/elevated privileges if they're not needed for installation.
	•	Do not require the user to close other applications.
	•	Do not create separate PPC/Intel Installers.  If you DO have a metapackage with separate payloads for separate architectures, perform your architecture check on the destination volume, not the currently booted operating system (See: Rule #1)
	•	Do not use an "Application First Run" script that requires administrator privileges to correctly setup the Application.

3  Licensing should have the option to be managed by Systems Administrators.

Licenses are manageable through the GUI, but the option for centrally managing licenses should exist transparently to the end user.  Whether you allow for a scriptable licensing interface, separate license files that exist OUTSIDE of the user's Home Directory, or license files controlled through preference manifests and MCX, there should be an option for Systems Administrators to license your software without prompting the user to enter a code.  Not only does this solve management and deployment issues, but it allows for separate installation and licensing packages to thwart unauthorized installation.  

	•	Do not place licensing and registration files in the user's home directory.
	•	DO read Rule 1 for placement of licensing and registration files.
	•	Do not build licensing/registration mechanisms into the installer GUI.
	•	Do allow a scriptable licensing interface to your software.

4 Use pre/post-install scripts only when necessary (and heed all other rules with your scripts).

Pre and Post-install scripts can be very helpful in specific situations, but if your intentions are to install files it's best to do that within a payload.  Many folks who use tools like Radmind, Puppet, Lanrev, and et cetera rely on having specific loadsets for every package.  It's much easier to use lsbom on a package and see exactly what will be installed rather than waiting for some third-party voodoo or post-install script to modify files (and then have to use fsevents to see what has changed).  Karl Kuehn once again provides some invaluable information: "If you can't avoid asking the user a question during the install (there are very, very few cases where this is actually acceptable), and can't put it in an installer plugin (note: these are not run with command-line installs), then you should probably be checking for the COMMAND_LINE_INSTALL environmental variable. If it is set, then you should avoid whatever it was you were going to do. If you can't do this for some reason, then it is time to go back to the drawing board (or developers) and figure it out again."

	•	Don't use post-install scripts to create or modify files - do this in the package payload.
	•	If you must use post-install scripts, don't use osascript to move and copy files (that's why we have cp/mv).
	•	GUI-based scripting can be hazardous to your health (See Rule #1)
	•	Do exit a script with 0 on success, or a non-zero number if there are errors.

5  Be true to the Operating System.

This nebulous rule covers all relevant suggestions dealing with the operating system onto which you're installing your package.  If you're going to support OS X back to version 10.4, then it goes without saying that you should TEST your package on every version from 10.4 up to the most current version.  
	•	Do test your package on all filesystems and versions that your package supports.
	•	Do use the documented OS X .pkg format (and not just a .pkg wrapper for some third party solution that installs the software for you).
	•	Do provide an uninstaller or uninstall script.
	•	Do follow the directory structure mandated by the target platform's software deployment guidelines.
	•	Do not change the ownership and permissions of core Operating System folders and files.
	•	Do keep your config data and cache data separate.

6  Naming Conventions are Necessary and Helpful.

Give your packages meaningful names and version numbers.  VPN.pkg is NOT helpful.  Providing your vendor and product name, along with important version numbers, will make Systems Administrators VERY happy when they try to sort out lists of packages.  

	•	Do list your vendor and product name in your package name.
	•	Do give packages meaningful names with version numbers.

So there you have it, an extensive (yet most likely INCOMPLETE) list of some of the biggest gripes from Sysadmins who have to maintain more than one Mac in their organization.  Please forgive the little errors (such as post-install instead of postinstall, if you prefer) and feel free to comment to your heart's content.  Hopefully those who package applications will read this and change their ways.  Until then, I'll be with everyone else who needs to repackage some Crappy App whose package installer just won't work...
