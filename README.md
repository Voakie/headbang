# headbang

This app measures the headbangs of the user using the gyroscope in the connected [eSense earable](https://www.esense.io/). The user can listen to predefined songs or set their own BPM target, to see how well they can match it.

## Screenshot

<img src="./Screenshot_Main_View.png" height="550px">

## Development

Clone the repository and open it in your favorite flutter IDE. Everything should be straightforward from then.

*Notice:* The songs displayed in the screenshot are not available in the public version of the app. To add your own songs, simply place
them in the `assets/songs` directory and edit the entries in the `lib/views/song_list_view` file. You might have to experiment with song encodings for it to work properly. (Easiest would be to convert it to MP3 via VLC)

## But why?

This small tech demo was created as part of an exercise for the Mobile Computing and Internet of Things
lecture at KIT