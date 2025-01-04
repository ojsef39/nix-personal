talos_context() {
  #!/bin/bash

  # Fetch all items from the vault "JHC" in the category "API Credential" with names containing "talos"
  items=$(op item list --vault "JHC" --categories "API Credential" --format json | jq -r '.[] | select(.title | contains("talos")) | .id + " " + .title')

  # Use fzf to select an item
  selected_item=$(echo "$items" | fzf --delimiter " " --with-nth 2.. | awk '{print $1}')

  # Fetch the credential field content from the selected item
  file_content=$(op item get "$selected_item" --vault "JHC" --format json | jq -r '.fields[] | select(.label == "text") | .value')

  # Write the file content to /tmp/talosconfig
  echo "$file_content" > /tmp/talosconfig

  # Export the talosconfig
  export TALOSCONFIG=/tmp/talosconfig

  # Run talosctl kubeconfig with the selected entry
  selected_title=$(echo "$items" | grep "$selected_item" | awk '{print $2}')
  talosctl kubeconfig --force ~/.kube/"$selected_title"
  talosctl dashboard
}
