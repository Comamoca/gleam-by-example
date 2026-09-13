{
  lib,
  newScope,
  beamPackages,
  buildGleam,
  fetchgit,
}:

let
  inherit (beamPackages) buildMix buildRebar3 fetchHex;
in

lib.makeScope newScope (self: {
  argv = buildGleam {
    name = "argv";
    version = "1.1.0";
    otpApplication = "argv";

    src = fetchHex {
      pkg = "argv";
      version = "1.1.0";
      sha256 = "sha256-MnfRAESL20opttWMDzb2McvDSei90JdmxjCd8gKDEUA=";
    };
  };

  directories = buildGleam {
    name = "directories";
    version = "1.2.0";
    otpApplication = "directories";

    src = fetchHex {
      pkg = "directories";
      version = "1.2.0";
      sha256 = "sha256-0TCQz832dZuHIX6N3XOnWQOnABSKgsHTN5nzM+JJv54=";
    };

    beamDeps = with self; [
      envoy
      gleam_stdlib
      platform
      simplifile
    ];
  };

  envoy = buildGleam {
    name = "envoy";
    version = "1.2.0";
    otpApplication = "envoy";

    src = fetchHex {
      pkg = "envoy";
      version = "1.2.0";
      sha256 = "sha256-nG+7a/oCpSeYvuxZd6c4ytbkoFf0tn/QyAYa0lAsGRo=";
    };

    beamDeps = with self; [
      gleam_stdlib
    ];
  };

  esqlite = buildRebar3 {
    name = "esqlite";
    version = "0.9.0";
    otpApplication = "esqlite";

    src = fetchHex {
      pkg = "esqlite";
      version = "0.9.0";
      sha256 = "sha256-zPciWKTuFS7HrZKqmgNVLrbKGwa2XJOtW25VwwLgWFU=";
    };
  };

  exception = buildGleam {
    name = "exception";
    version = "2.1.1";
    otpApplication = "exception";

    src = fetchHex {
      pkg = "exception";
      version = "2.1.1";
      sha256 = "sha256-a96pUkgJNZk5HDtd8YNcXGqGw1PC+ZzlObRQ40Mv4Rc=";
    };

    beamDeps = with self; [
      gleam_stdlib
    ];
  };

  filepath = buildGleam {
    name = "filepath";
    version = "1.1.2";
    otpApplication = "filepath";

    src = fetchHex {
      pkg = "filepath";
      version = "1.1.2";
      sha256 = "sha256-sGqa8L8Q5RQB1kuY5LYn8dLkjBVJZ9p69NCRR4Cm1Ao=";
    };

    beamDeps = with self; [
      gleam_stdlib
    ];
  };

  gleam_community_ansi = buildGleam {
    name = "gleam_community_ansi";
    version = "1.5.0";
    otpApplication = "gleam_community_ansi";

    src = fetchHex {
      pkg = "gleam_community_ansi";
      version = "1.5.0";
      sha256 = "sha256-tapDOvhDE+I/35DM/3Urk4D+n/zgKylJ1Jt6rMx3sW0=";
    };

    beamDeps = with self; [
      gleam_community_colour
      gleam_regexp
      gleam_stdlib
    ];
  };

  gleam_community_colour = buildGleam {
    name = "gleam_community_colour";
    version = "2.0.4";
    otpApplication = "gleam_community_colour";

    src = fetchHex {
      pkg = "gleam_community_colour";
      version = "2.0.4";
      sha256 = "sha256-bbRmVVXX0rJ/DqMu9H6L68QwOCF2X5xz1IPzjuJIlPA=";
    };

    beamDeps = with self; [
      gleam_json
      gleam_stdlib
    ];
  };

  gleam_crypto = buildGleam {
    name = "gleam_crypto";
    version = "1.6.0";
    otpApplication = "gleam_crypto";

    src = fetchHex {
      pkg = "gleam_crypto";
      version = "1.6.0";
      sha256 = "sha256-Lenk71PPb+4EnU92VzH3F496Ea764A7uY791NrNUrT8=";
    };

    beamDeps = with self; [
      gleam_stdlib
    ];
  };

  gleam_erlang = buildGleam {
    name = "gleam_erlang";
    version = "1.3.0";
    otpApplication = "gleam_erlang";

    src = fetchHex {
      pkg = "gleam_erlang";
      version = "1.3.0";
      sha256 = "sha256-ESStOqIRQ+WvD8XPPZUp9tuMoD5DpVcRtgtrezh0N1w=";
    };

    beamDeps = with self; [
      gleam_stdlib
    ];
  };

  gleam_http = buildGleam {
    name = "gleam_http";
    version = "4.4.0";
    otpApplication = "gleam_http";

    src = fetchHex {
      pkg = "gleam_http";
      version = "4.4.0";
      sha256 = "sha256-8GXOmUGndWq7rq5/nzKpbK0p2jMRo4HbLZJuqOjBVtw=";
    };

    beamDeps = with self; [
      gleam_stdlib
    ];
  };

  gleam_json = buildGleam {
    name = "gleam_json";
    version = "3.1.0";
    otpApplication = "gleam_json";

    src = fetchHex {
      pkg = "gleam_json";
      version = "3.1.0";
      sha256 = "sha256-RP2qiEe+j8SMp6HAiXBr1UutzExFsjepku3fnyzbKDY=";
    };

    beamDeps = with self; [
      gleam_stdlib
    ];
  };

  gleam_otp = buildGleam {
    name = "gleam_otp";
    version = "1.3.0";
    otpApplication = "gleam_otp";

    src = fetchHex {
      pkg = "gleam_otp";
      version = "1.3.0";
      sha256 = "sha256-3kymhQhC8CZu6VMXol3WoKDyDN+rfArcLmMlHXw8cuw=";
    };

    beamDeps = with self; [
      gleam_erlang
      gleam_stdlib
    ];
  };

  gleam_regexp = buildGleam {
    name = "gleam_regexp";
    version = "1.1.1";
    otpApplication = "gleam_regexp";

    src = fetchHex {
      pkg = "gleam_regexp";
      version = "1.1.1";
      sha256 = "sha256-nCFcbKhKWzW7k0qbYamjBux0MVO+KwQloNAy5HewYqk=";
    };

    beamDeps = with self; [
      gleam_stdlib
    ];
  };

  gleam_stdlib = buildGleam {
    name = "gleam_stdlib";
    version = "1.0.5";
    otpApplication = "gleam_stdlib";

    src = fetchHex {
      pkg = "gleam_stdlib";
      version = "1.0.5";
      sha256 = "sha256-zuW2wHaoW0X2DFhfQxbGPsi3EnwRnVc4w5WKnE1QQE4=";
    };
  };

  gleam_time = buildGleam {
    name = "gleam_time";
    version = "1.10.0";
    otpApplication = "gleam_time";

    src = fetchHex {
      pkg = "gleam_time";
      version = "1.10.0";
      sha256 = "sha256-VlOSFuTEsXSHFGUqs48L0WuRAfYdtidp/cfNQqjl6DM=";
    };

    beamDeps = with self; [
      gleam_stdlib
    ];
  };

  gleeunit = buildGleam {
    name = "gleeunit";
    version = "1.11.0";
    otpApplication = "gleeunit";

    src = fetchHex {
      pkg = "gleeunit";
      version = "1.11.0";
      sha256 = "sha256-7DGrp0JWrqUx7fgWmTHXdbuzhP7QqKG9xN2TVOPiGCY=";
    };

    beamDeps = with self; [
      gleam_stdlib
    ];
  };

  glint = buildGleam {
    name = "glint";
    version = "1.3.0";
    otpApplication = "glint";

    src = fetchHex {
      pkg = "glint";
      version = "1.3.0";
      sha256 = "sha256-JsypvDrLVs2ddUrPWY9JtMKBxP3YGuYfohyOkunIIY4=";
    };

    beamDeps = with self; [
      gleam_community_ansi
      gleam_community_colour
      gleam_stdlib
      snag
    ];
  };

  glisten = buildGleam {
    name = "glisten";
    version = "9.0.1";
    otpApplication = "glisten";

    src = fetchHex {
      pkg = "glisten";
      version = "9.0.1";
      sha256 = "sha256-d5WqUIMGVvOgMWprJllfiTyDJy2pAbNAXjEznKoxoQs=";
    };

    beamDeps = with self; [
      gleam_erlang
      gleam_otp
      gleam_stdlib
      logging
    ];
  };

  gramps = buildGleam {
    name = "gramps";
    version = "6.0.1";
    otpApplication = "gramps";

    src = fetchHex {
      pkg = "gramps";
      version = "6.0.1";
      sha256 = "sha256-1VY2By3uFz9lhqVnnTwC7HoN4/hka3jDUbcpCP8iPfc=";
    };

    beamDeps = with self; [
      gleam_crypto
      gleam_erlang
      gleam_http
      gleam_stdlib
    ];
  };

  hpack_erl = buildRebar3 {
    name = "hpack_erl";
    version = "0.3.0";
    otpApplication = "hpack";

    src = fetchHex {
      pkg = "hpack_erl";
      version = "0.3.0";
      sha256 = "sha256-1hN9cHkWnYxIXGli3+Jhr1ue9g+8VXNEURweZePZX7A=";
    };
  };

  logging = buildGleam {
    name = "logging";
    version = "1.5.0";
    otpApplication = "logging";

    src = fetchHex {
      pkg = "logging";
      version = "1.5.0";
      sha256 = "sha256-vF8Yzl3ZaGEAIp/lQJvcPdXEbVp98vgErS2PDdbFBg4=";
    };

    beamDeps = with self; [
      gleam_stdlib
    ];
  };

  mist = buildGleam {
    name = "mist";
    version = "6.0.3";
    otpApplication = "mist";

    src = fetchHex {
      pkg = "mist";
      version = "6.0.3";
      sha256 = "sha256-GwfzIdX6DLFi2BSW8t6WrrbviYD084IwpMw/hJSX4CA=";
    };

    beamDeps = with self; [
      exception
      gleam_erlang
      gleam_http
      gleam_otp
      gleam_stdlib
      glisten
      gramps
      hpack_erl
      logging
    ];
  };

  platform = buildGleam {
    name = "platform";
    version = "1.0.0";
    otpApplication = "platform";

    src = fetchHex {
      pkg = "platform";
      version = "1.0.0";
      sha256 = "sha256-gzlCCpWtiarA+C9MPbjdQBBBdC1sP0YTKoc59q63U5E=";
    };
  };

  simplifile = buildGleam {
    name = "simplifile";
    version = "2.7.0";
    otpApplication = "simplifile";

    src = fetchHex {
      pkg = "simplifile";
      version = "2.7.0";
      sha256 = "sha256-onJ2J7Bj6HNRk0x/fwCPLR/bFvbeC4x5+eRkWc/JwWQ=";
    };

    beamDeps = with self; [
      filepath
      gleam_stdlib
    ];
  };

  snag = buildGleam {
    name = "snag";
    version = "1.2.0";
    otpApplication = "snag";

    src = fetchHex {
      pkg = "snag";
      version = "1.2.0";
      sha256 = "sha256-J09B1sPs+Z92hv3OVBgzM+QdLBylo6Zz+aiyx6RAEHc=";
    };

    beamDeps = with self; [
      gleam_stdlib
    ];
  };

  sqlight = buildGleam {
    name = "sqlight";
    version = "1.2.0";
    otpApplication = "sqlight";

    src = fetchHex {
      pkg = "sqlight";
      version = "1.2.0";
      sha256 = "sha256-hBdo0KgRB+4ttGuUk1TyhKaLLoCYMVwoof48B9IGwXo=";
    };

    beamDeps = with self; [
      esqlite
      gleam_stdlib
    ];
  };

  sqlode = buildGleam {
    name = "sqlode";
    version = "0.31.0";
    otpApplication = "sqlode";

    src = fetchHex {
      pkg = "sqlode";
      version = "0.31.0";
      sha256 = "sha256-kGYoT+xs6wmYU+2zzvc6EwchSZw2GCR1Vn3Ia/HA6vE=";
    };

    beamDeps = with self; [
      argv
      filepath
      gleam_regexp
      gleam_stdlib
      glint
      simplifile
      yay
    ];
  };

  storail = buildGleam {
    name = "storail";
    version = "3.2.0";
    otpApplication = "storail";

    src = fetchHex {
      pkg = "storail";
      version = "3.2.0";
      sha256 = "sha256-DIrO7gEllRTD1PZugRufb5WSx6brwHOljkpv6Xp65QU=";
    };

    beamDeps = with self; [
      directories
      filepath
      gleam_crypto
      gleam_json
      gleam_stdlib
      simplifile
    ];
  };

  yamerl = buildRebar3 {
    name = "yamerl";
    version = "0.10.0";
    otpApplication = "yamerl";

    src = fetchHex {
      pkg = "yamerl";
      version = "0.10.0";
      sha256 = "sha256-NGrbKWPxBR3IN6I2TkrPbrfYAJfA9Ty9wwRuyOxLTm4=";
    };
  };

  yay = buildGleam {
    name = "yay";
    version = "2.0.2";
    otpApplication = "yay";

    src = fetchHex {
      pkg = "yay";
      version = "2.0.2";
      sha256 = "sha256-sgj5oU+iteMGcogSgUsB52C8fzvKxL1oienKgIis/Ug=";
    };

    beamDeps = with self; [
      gleam_stdlib
      yamerl
    ];
  };

  youid = buildGleam {
    name = "youid";
    version = "1.6.0";
    otpApplication = "youid";

    src = fetchHex {
      pkg = "youid";
      version = "1.6.0";
      sha256 = "sha256-ejq6RLGzi8K9y1R0xTF6o3K+WN+8ZJgV7giwNSbdoY0=";
    };

    beamDeps = with self; [
      gleam_crypto
      gleam_stdlib
      gleam_time
    ];
  };
})
