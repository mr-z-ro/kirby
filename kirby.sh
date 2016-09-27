#!/bin/bash
AUDIO_FILE="/tmp/kirby-last-command.wav" # where should the file go?
CONTENT_TYPE="audio/wav" # audio/x-flac or audio/wav or audio/x-raw
RATE="16000" # rate to include in header
RATE_ABBR="16k" # abbreviated rate
PRECISION="16" # 16b or 32b
CHANNELS="1" # Mono=1, Stereo=2

# Wait for a vocal command to start
# Note, for api.ai sound files must be 16000 Hz, Signed PCM, 16 bit, and mono
/usr/local/bin/rec \
  -c 1 \
  -b 16 \
  $AUDIO_FILE \
  rate $RATE_ABBR \
  silence 1 0.05 1% 1 1.0 1%

# Play back the recording using SoX play (uncomment for testing purposes)
# /usr/local/bin/play $AUDIO_FILE

# Send to the Voice-to-Text processor

## Google Speech using curl:
# KEY=$(/bin/cat GSPEECH_KEY)
# curl -X POST \
# --upload-file $AUDIO_FILE \
# --header 'Content-Type: audio/x-flac; rate=$RATE;' \
# --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.77 Safari/535.7' \
# "https://www.google.com/speech-api/v2/recognize?output=json&lang=en-us&client=chromium&key=$KEY"

## Google Speech using wget:
# wget -q -U “Mozilla/5.0” \
#  –post-file file.flac \
#  –header “Content-Type: audio/x-flac; rate=$RATE” \
#  -O – “http://www.google.com/speech-api/v1/recognize?lang=en-us&client=chromium” \
#  | cut -d” -f12 > /tmp/stt.txt

# api.ai 
APIAI_ACCESS_TOKEN=$(/bin/cat APIAI_ACCESS_TOKEN)
APIAI_SUBSCRIPTION_KEY=$(/bin/cat APIAI_SUBSCRIPTION_KEY)
BASE_URL="https://api.api.ai/v1"
RESPONSE=$(/usr/bin/curl -k \
  -F "request={'timezone':'America/New_York', 'lang':'en'};type=application/json" \
  -F "voiceData=@$AUDIO_FILE;type=$CONTENT_TYPE" \
  -H "Authorization: Bearer $APIAI_ACCESS_TOKEN" \
  -H "ocp-apim-subscription-key: $APIAI_SUBSCRIPTION_KEY" \
  "$BASE_URL/query?v=20150910" \
  --progress-bar )


# Debug
/usr/bin/printf "####\n$RESPONSE\n####\n"

# Write the interpreted result
RESOLVED_QUERY=$(echo $RESPONSE | jq '.result.resolvedQuery')
/bin/echo "$RESOLVED_QUERY"

# Read aloud the response (Veena or Tessa seem to be nice voices)
SPEECH_RESPONSE=$(echo $RESPONSE | jq '.result.fulfillment.speech')
/bin/echo $SPEECH_RESPONSE | say -v Veena -r 253
