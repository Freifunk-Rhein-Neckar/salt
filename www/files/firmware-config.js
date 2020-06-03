/*
 * File managed by Salt. Your changes will be overwritten!
 */

 var config = {
    // list images on console that match no model
    listMissingImages: false,
    // see devices.js for different vendor model maps
    vendormodels: vendormodels,
    // set enabled categories of devices (see devices.js)
    //enabled_device_categories: ["recommended"],
    enabled_device_categories: ["recommended", "4_32", "8_32", "16_32", "ath10k_lowmem"],
    // Display a checkbox that allows to display not recommended devices.
    // This only make sense if enabled_device_categories also contains not
    // recommended devices.
    recommended_toggle: true,
    // Optional link to an info page about no longer recommended devices
    recommended_info_link: null,
    // community prefix of the firmware images
    community_prefix: 'gluon-ffrn-',
    // firmware version regex
    version_regex: '-([0-9]+.[0-9]+.[0-9x]+([+-~][0-9]+)?)[.-]',
    // relative image paths and branch
    directories: {
      './images/stable/factory/': 'stable',
      './images/stable/sysupgrade/': 'stable',
      './images/stable/other/': 'stable',
      './images/beta/factory/': 'beta',
      './images/beta/sysupgrade/': 'beta',
      './images/beta/other/': 'beta',
      './images/experimental/factory/': 'experimental',
      './images/experimental/sysupgrade/': 'experimental',
      './images/experimental/other/': 'experimental',
      './images/nightly/factory/': 'nightly',
      './images/nightly/sysupgrade/': 'nightly',
      './images/nightly/other/': 'nightly'
    },
    // page title
    title: 'Freifunk Rhein-Neckar Firmware',
    // branch descriptions shown during selection
    branch_descriptions: {
      stable: 'Gut getestet, zuverlässig und stabil.',
      beta: 'Vorabtests neuer Stable-Kandidaten.',
      experimental: 'Ungetestet, teilautomatisch generiert.',
      nightly: 'Absolut ungetestet, automatisch generiert. Nur für absolute Experten.'
    },
    // recommended branch will be marked during selection
    recommended_branch: 'stable',
    // experimental branches (show a warning for these branches)
    experimental_branches: ['experimental', 'nightly'],
    // path to preview pictures directory
    preview_pictures: 'pictures/',
    // link to changelog
    changelog: 'https://forum.ffrn.de/c/technik/firmware',

    color_accent: '#52995d'
  };
