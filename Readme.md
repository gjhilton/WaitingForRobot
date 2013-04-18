#Waiting For Robot
##An automatic never-ending tragicomedy.

W4R is a playscript that writes - and then performs itself.

##To Build
### Step 1

You need to prepare two raw text files, one monologue, one main scene. 
The monologue is just straight text - easy, but the main scene requires a little preparation:

1) remove the speakers - ie "Romeo: But soft..." should become just "But soft..."

2) remove stage directions

3) remove blank lines

4) replace any occurrences of character names with ^CHARACTERNAME^ - ie "Romeo, Romeo, wherefore art though Romeo?" becomes ""
"^CHARACTERNAME^, ^CHARACTERNAME^, wherefore art thou ^CHARACTERNAME^?"

At this point your text should look something like

Hello ^CHARACTERNAME^, how are you?
Fine thank you.

### Step 2

Edit the paths in AppDelegate.m to point to your raw files. You're going to use these to create processed 'corpora' files which will be bundled into the app. To do this, compile with the flag #define USE_RAW_TEXT_CORPORA and run the app. IT'll take a minute or so, but this will build the files you need. Once you have these, unset the flag, add them to the app bundle, rebuild, and you're good to go.

Copyright (c) 2013 g j hilton. All rights reserved.