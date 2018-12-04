// ==UserScript==
// @name     noprocrast
// @version  1.1.0
// @grant    *
// ==/UserScript==

/**
 * ==== noprocrast ====
 *
 * Copyright (C) 2018 Declan Freeman-Gleason
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * === Info ===
 *
 * This is a Greasemonkey script. You can load it by clicking on "Import New User Script".
 * Edit the regular expressions in the "allowedSites" variable to allow sites, or to remove
 * a site from the whitelist.
 *
 */

const allowedSites = [
	/^.*\.google.com/,
  /^.*\.gutenberg.org/,
  /^.*\.thesaurus.com/,
  /^.*\.grammarly.com/,
  /^.*bisd303.org/,
  /^.*spanishdict.com/,
  /^.*localhost/,
];

for (let i = 0; i < allowedSites.length; i++) {
  if (allowedSites[i].test(window.location.host))
    return;
}
displayBlockPage();

function displayBlockPage() {
  console.log("Page blocked. Get back to work.");
  window.stop();
  document.head.innerHTML = "<title>Get Back to Work!</title>";
  document.body.innerHTML = `
<style>
code {
  border-radius: 3px;
  background-color: lightgray;
  padding: calc(1em / 2);
}
</style>
<center>
  <h1>Get back to work!</h1>
  <h3><code>${window.location.href}</code> does not match the whitelist:<h3>
  <code style="width: 20%; display: block;">
    ${allowedSites}
  </code>
</center>
`;
  stripAttributes(document.head.attributes);
  stripAttributes(document.body.attributes);
}

function stripAttributes(namedNodeMap) {
  for (let i = 0; i < namedNodeMap.length; i++) {
    document.body.attributes.removeNamedItem(namedNodeMap.name);
  }
}
