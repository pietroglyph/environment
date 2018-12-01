#!/bin/bash

function setTitle() {
	sleep 10 # Assumes that Firefox takes no more than 10 seconds to start, and Slack takes no more than 10 seconds to load
	i3-msg '[title="Slack - Mozilla Firefox"] title_format Slack'
}

setTitle &
firefox --P app --no-remote --new-tab "https://spartronics.slack.com"
