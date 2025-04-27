# Function to display and launch Talos dashboard with all nodes
function talos_dashboard
    # Get all cluster members
    echo "🔍 Fetching cluster members..."

    # Parse member hostnames
    set -l control_hostnames
    set -l worker_hostnames
    set -l nodes_args

    # Process the output line by line
    for line in (talosctl get members -o yaml | grep "hostname:" | awk '{print $2}')
        set node_hostname (string trim $line)
        if test -n "$node_hostname"
            # Check if it's a control plane node
            if string match -q "*control*" "$node_hostname"
                set -a control_hostnames $node_hostname
            else
                set -a worker_hostnames $node_hostname
            end
            # Add to nodes_args array
            set -a nodes_args -n $node_hostname
        end
    end

    # If no members were found, run dashboard without -n flags
    if test (count $nodes_args) -eq 0
        echo "⚠️ No cluster members found. Running dashboard without node specification."
        talosctl dashboard
    else
        echo "🚀 Starting dashboard with nodes:"

        # Display control plane nodes first with special marker
        for node_hostname in $control_hostnames
            echo "* 🎮 $node_hostname"
        end

        # Display worker nodes
        for node_hostname in $worker_hostnames
            echo "* 🖥️ $node_hostname"
        end

        # Run the dashboard with proper array expansion
        talosctl dashboard $nodes_args

        # Return with a clean exit code
        return 0
    end
end

# Main function to set up Talos context and launch dashboard
function talos_context
    # Fetch all items from the vault "JHC" in the category "API Credential" with names containing "talos"
    set items (op item list --vault "JHC" --categories "API Credential" --format json | jq -r '.[] | select(.title | contains("talos")) | .id + " " + .title')

    # Process items into a format that fzf can display line by line
    set formatted_items
    for item in $items
        set -a formatted_items "$item"
    end

    # Use fzf to select an item
    set selected_item (printf "%s\n" $formatted_items | fzf --delimiter " " --with-nth 2.. | awk '{print $1}')

    # If no item was selected, exit the function
    if test -z "$selected_item"
        echo "No item selected. Exiting."
        return 1
    end

    # Extract the title from the selected item
    set selected_title (printf "%s\n" $formatted_items | grep "$selected_item" | awk '{$1=""; print substr($0,2)}')

    op item get "$selected_item" --vault JHC --format json | jq -r '.fields[] | select(.label == "text") | .value' >/tmp/talosconfig

    # Set environment variable
    set -gx TALOSCONFIG /tmp/talosconfig

    # Generate kubeconfig
    mkdir -p ~/.kube
    talosctl kubeconfig --force ~/.kube/config

    # Copy the config file with the selected title
    if test -n "$selected_title" -a -f ~/.kube/config
        cp ~/.kube/config ~/.kube/"$selected_title"
    end
end
