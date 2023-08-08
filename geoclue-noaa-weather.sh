#!/usr/bin/env bash

raw_output="$(/usr/lib/geoclue-2.0/demos/where-am-i -t 0 | tr "\n" " ")"
suffix_regex=": *(-?[0-9]*\.?[0-9]*)"

export lat=47.642808
export long=-122.510315
if [[ "$raw_output" =~ Latitude${suffix_regex} ]]
then
	export lat="${BASH_REMATCH[1]}"
fi
if [[ "$raw_output" =~ Longitude${suffix_regex} ]]
then
	export long="${BASH_REMATCH[1]}"
fi

# Could start from here, but that's kind of a pain
hcurl() {
	curl -A '(personal weather widget, porkcrafter3000.dev@gmail.com)' -H 'Accept: application/geo+json' $@
}

forecast_url=$(hcurl -sL "https://api.weather.gov/points/${lat},${long}" | jq -r '.properties.forecast')
hcurl -sL "${forecast_url}" | jq '[.properties.periods[range(2)] | [.temperature, "°", .temperatureUnit, (select((.shortForecast | length <= 10) or (.number > 1)) | " ", .shortForecast), (select(.probabilityOfPrecipitation.value != null) | " (", .probabilityOfPrecipitation.value, "%)")] | join("")] | join(" → ")'
