{ glibc, writeTextFile }:
let
  name = "en_US@custom.UTF-8";
  destination = "/share/i18n/locales/${name}";
in
writeTextFile {
  inherit name destination;
  text = ''
    comment_char %
    escape_char /

    % English Language Locale for English with Euro and ISO 8601 dates
    % Language: en
    % Territory: US
    % Option: euro
    % Date: 2024-09-05
    % Users: general

    LC_IDENTIFICATION
    title      "English locale with Euro and ISO 8601 dates"
    source     "custom"
    address    "custom"
    contact    ""
    email      "custom"
    tel        ""
    fax        ""
    language   "English"
    territory  "US"
    revision   "1.0"
    date       "2024-09-05"

    category "i18n:2012";LC_IDENTIFICATION
    category "i18n:2012";LC_CTYPE
    category "i18n:2012";LC_COLLATE
    category "i18n:2012";LC_TIME
    category "i18n:2012";LC_NUMERIC
    category "i18n:2012";LC_MONETARY
    category "i18n:2012";LC_MESSAGES
    category "i18n:2012";LC_PAPER
    category "i18n:2012";LC_NAME
    category "i18n:2012";LC_ADDRESS
    category "i18n:2012";LC_TELEPHONE
    category "i18n:2012";LC_MEASUREMENT
    END LC_IDENTIFICATION

    LC_COLLATE
    copy "en_US"
    END LC_COLLATE

    LC_CTYPE
    copy "en_US"
    END LC_CTYPE

    LC_MESSAGES
    copy "en_US"
    END LC_MESSAGES

    LC_MONETARY
    copy "it_IT"
    END LC_MONETARY

    LC_NUMERIC
    copy "en_US"
    END LC_NUMERIC

    LC_TIME
    abday   "Sun";"Mon";"Tue";"Wed";"Thu";"Fri";"Sat"
    day     "Sunday";/
            "Monday";/
            "Tuesday";/
            "Wednesday";/
            "Thursday";/
            "Friday";/
            "Saturday"

    week 7;19971130;1
    abmon   "Jan";"Feb";/
            "Mar";"Apr";/
            "May";"Jun";/
            "Jul";"Aug";/
            "Sep";"Oct";/
            "Nov";"Dec"
    mon     "January";/
            "February";/
            "March";/
            "April";/
            "May";/
            "June";/
            "July";/
            "August";/
            "September";/
            "October";/
            "November";/
            "December"
    d_t_fmt "%a %b %FT%T%:z"
    d_fmt   "%Y-%m-%d"
    t_fmt   "%T"
    am_pm   "";""
    t_fmt_ampm ""
    date_fmt   "%a %b %FT%T%:z"
    first_weekday 2
    END LC_TIME

    LC_PAPER
    copy "it_IT"
    END LC_PAPER

    LC_TELEPHONE
    copy "it_IT"
    END LC_TELEPHONE

    LC_MEASUREMENT
    copy "it_IT"
    END LC_MEASUREMENT

    LC_NAME
    copy "en_US"
    END LC_NAME

    LC_ADDRESS
    copy "en_US"
    END LC_ADDRESS
  '';
  checkPhase = ''
    set -eu
    ${glibc.bin}/bin/localedef -i "$out/${destination}" --no-archive -f UTF-8 $TEMP/en_US@custom.UTF-8
  '';
}
