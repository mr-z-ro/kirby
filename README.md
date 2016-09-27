# Kirby

Kirby is a voice recognition mashup created for compiling commands on MacOS.
It utilizes SoX for audio input, Google's Speech API for speech-to-text, and
a mashup of other engines from there to process the request. Finally any audio
output as a result is completed using the classic "say" command.

## Prerequisites
1. A computer running MacOS

2. You'll need to install SoX with flax support, which can easily be done in
   Homebrew with the following command:

```
brew install sox --with-flac
```

3. You'll need a machine that can support cURL

4. [Google Speech Only] An API key for Google Speech, saved in a file called
   GSPEECH_KEY as the only contents. This is referenced by kirby.sh for making
   Google Speech Calls.

   [api.ai Only] An access token, saved in a file called APIAI_ACCESS_TOKEN
   as the only contents. A subscription key for the agent, saved in a file called
   APIAI_SUBSCRIPTION_KEY as the only contents. These are both referenced by
   kirby.sh for making api.ai calls.

## References

### SoX Record command format reference

```
rec [outputfile.extension] \
  rate [sample rate] \
  silence \
    [above-period:0|1] [time] [threshold %] \
    [below-period:-1|1] [time] [threshold %]
```

For example, the following command records after silence is broken and ends 
3 seconds after silence has started again:

```
rec recording.wav rate 8k silence 1 0.1 3% 1 3.0 3%
```

This roughly translates to "Record audio to the file recording.wav at a sample
rate of 8kHz. Start recording 0.1sec after the audio is 3% above true silence,
and continue recording until 3 seconds of audio that is 3% above true silence.

More info here: http://digitalcardboard.com/blog/2009/08/25/the-sox-of-silence/

### Google Speech Response reference

For some reason or another Google Speech API includes two json responses in the
HTTP response. I imagine it's for when they have 100% confidence, they can put
that in the first one, hence the "alternative" tag in the second ;)

Please note that each response is on a single line, and that the second response
here is manually formatted by me for readability.

```
{"result":[]}
{"result":[
  {"alternative": [
    {"transcript":"hello this is only a test","confidence":0.98590767},
    {"transcript":"yellow this is only a test"},
    {"transcript":"El oh this is only a test"},
    {"transcript":"hello this is only a text"},
    {"transcript":"well oh this is only a test"}
  ],
  "final":true}
],
"result_index":0}
```

### api.ai API Documentation

Can be found here: https://docs.api.ai/docs/reference

## Acknowledgements

Raspberry Pi voice recognition by Oscar Liang was a huge help:
http://blog.oscarliang.net/raspberry-pi-voice-recognition-works-like-siri/

This wonderful reference from DigitalCardboard on SoX and silence trimming
was also tremendously helpful:
http://digitalcardboard.com/blog/2009/08/25/the-sox-of-silence/

This introduction to getting the api key for the Speech API was critical:
http://www.chromium.org/developers/how-tos/api-keys

"Reverse Engineering" (author's name, not mine) of Google Speech V2 was
an interesting read:
https://aminesehili.wordpress.com/2015/02/08/on-the-use-of-googles-speech-recognition-api-version-2/
