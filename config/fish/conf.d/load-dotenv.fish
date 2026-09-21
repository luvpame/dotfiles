set -l dotenv_file "$HOME/.config/fish/.env"

# 1Password mounts local .env files as named pipes (FIFOs).
if test -f "$dotenv_file"; or test -p "$dotenv_file"
  while read -l raw_line
    set -l line (string trim -- $raw_line)

    if test -z "$line"
      continue
    end

    if string match -qr '^#' -- $line
      continue
    end

    # Support both "KEY=value" and "export KEY=value".
    set line (string replace -r '^export[[:space:]]+' '' -- $line)

    if not string match -qr '^[A-Za-z_][A-Za-z0-9_]*=' -- $line
      continue
    end

    set -l key (string replace -r '=.*$' '' -- $line)
    set -l value (string replace -r '^[^=]*=' '' -- $line)

    # Trim only one pair of wrapping quotes.
    set -l value_length (string length -- $value)
    if test $value_length -ge 2
      set -l first_char (string sub -s 1 -l 1 -- $value)
      set -l last_char (string sub -s -1 -- $value)

      if test "$first_char" = '"' -a "$last_char" = '"'
        set value (string sub -s 2 -e -1 -- $value)
      else if test "$first_char" = "'" -a "$last_char" = "'"
        set value (string sub -s 2 -e -1 -- $value)
      end
    end

    set -gx $key $value
  end < $dotenv_file
end
