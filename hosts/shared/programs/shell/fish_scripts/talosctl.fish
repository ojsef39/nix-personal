# Function to display and launch Talos dashboard with all nodes
function talos_dashboard
    # Get all cluster members
    echo "🔍 Fetching cluster members..."
    set members_output (talosctl get members -o yaml)

    # Parse member hostnames
    set -l control_hostnames
    set -l worker_hostnames
    set -l nodes_args

    for line in (echo $members_output | grep "hostname:" | awk '{print $2}')
        set hostname (string trim $line)
        if test -n "$hostname"
            # Check if it's a control plane node
            if string match -q "*control*" "$hostname"
                set -a control_hostnames $hostname
            else
                set -a worker_hostnames $hostname
            end
            # Add to nodes_args array
            set -a nodes_args -n $hostname
        end
    end

    # If no members were found, run dashboard without -n flags
    if test (count $nodes_args) -eq 0
        echo "⚠️ No cluster members found. Running dashboard without node specification."
        talosctl dashboard
    else
        echo "🚀 Starting dashboard with nodes:"

        # Display control plane nodes first with special marker
        for hostname in $control_hostnames
            echo "* 🎮 $hostname"
        end

        # Display worker nodes
        for hostname in $worker_hostnames
            echo "* 🖥️ $hostname"
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

    # Use fzf to select an item
    set selected_item (echo "$items" | fzf --delimiter " " --with-nth 2.. | awk '{print $1}')

    # If no item was selected, exit the function
    if test -z "$selected_item"
        echo "No item selected. Exiting."
        return 1
    end

    # Extract the title from the selected item
    set selected_title (echo "$items" | grep "$selected_item" | awk '{$1=""; print substr($0,2)}')

    # Fetch the credential field content from the selected item
    set file_content (op item get "$selected_item" --vault "JHC" --format json | jq -r '.fields[] | select(.label == "text") | .value')

    # Write the file content to /tmp/talosconfig
    echo "$file_content" >/tmp/talosconfig
    set -gx TALOSCONFIG /tmp/talosconfig

    # Generate kubeconfig
    talosctl kubeconfig --force ~/.kube/config
    cp ~/.kube/config ~/.kube/"$selected_title"
end
