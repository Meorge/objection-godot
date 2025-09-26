# Payne Scripting Format

## Overall structure

A simple Payne script looks like this:

```xml
<payne>
    <cast>
        <character id="user1" display_name="Guy One" character="phoenix" />
        <character id="user2" display_name="Guy 2" character="edgeworth" />
        <character id="user3" display_name="The Third Guy" character="larry" />
        <character id="user4" display_name="The Pizza Judge" character="judge" />
    </cast>
    <conversation>
        <startmusic res="res://audio/music/pwr/cross-moderato.wav"/>
        <dialog id="user1">Hi everyone, what's up?</dialog>
        <dialog id="user3" evidence="pineapple-pizza.png">Oh hey, I was just about to eat this pineapple pizza. Want some?</dialog>
        <stopmusic/>
        <objection id="user2" />
        <startmusic res="res://audio/music/pwr/press.wav"/>
        <dialog id="user3">Pineapple on pizza? That's ridiculous!</dialog>
        <gavel slams="3" />
        <dialog id="user4">I hereby declare pineapple on pizza... perfectly tasty!</dialog>
    </conversation>
</payne>
```

There are two main sections to it:

- Inside the `<cast>` section, each character is defined with a `<character />` element. Each of these elements must have the following attributes:
  - An `id`, which uniquely identifies that character.
  - A `display_name`, which is displayed on the dialogue text box.
  - A `character`, which should be a valid Objection-Godot character ID.
- The `<conversation>` section lists out each step of the conversation to be rendered. Most commonly, you will use the `<dialog>` command to add text from a given character. See below for a full list and explanation of the conversation commands.

## Conversation commands

### `<dialog>` - Display text spoken by a character

Wrap text in a `<dialog>` command to have it be spoken by the character indicated by its `id` attribute:

```xml
<dialog id="meorge">Hi, my name is Meorge!</dialog>
```

By default, a random animation will be chosen for the character the ID is associated with. You can override this by providing a specific animation name in the optional `anim` attribute:

```xml
<dialog id="meorge" anim="angry">Grrr, I'm really miffed about this!</dialog>
```

To display an image as a piece of evidence on-screen at the same time as this dialogue, pass a path to the image file in the optional `evidence` attribute:

```xml
<dialog id="meorge" evidence="~/really_cool_drawing.png">Check out this drawing! Isn't it the coolest?</dialog>
```

### `<objection>`, `<holdit>`, `<takethat>` - Display an exclamation bubble from a character

Use one of these commands to display the respective exclamation bubble:

```xml
<objection id="meorge" />
<takethat id="johnny" />
```

If the character that the ID is associated with has a voice clip that corresponds to that bubble type, it will be played. Otherwise, a voice-less version will be played instead.

### `<startmusic>`, `<stopmusic>` - Start or stop music

Use the `<startmusic>` command to start playing a music track at the path given by the `res` attribute:

```xml
<startmusic res="res://audio/music/pwr/cross-moderato.wav" />
```

Likewise, use the `<stopmusic>` command to immediately stop the currently playing music track:

```xml
<stopmusic />
```

### `<gavel>` - Display the "gavel slam" animation

Use the `<gavel>` command to play the "gavel slam" animation, with the gavel being slammed the number of times given by the `slams` attribute:

```xml
<gavel slams="3" />
```

### `<newevidence>` - Display the "new evidence" box

Use the `<newevidence>` command to display a pop-up window showing an icon, a title, and a description (the same window that shows up in *Ace Attorney* games when something is added to the Court Record):

```xml
<newevidence title="Something New" description="This is a new piece of evidence. How exciting!" res="~/my_new_evidence.png" />
```
