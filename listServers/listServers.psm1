# Define the module
function Add-ServersFromCollectionToArray([string]$connectionBroker, [string]$collectionName) {
	# Retrieve the session hosts from the specified collection on the connection broker
	$servers = Get-RDSessionHost -CollectionName $collectionName -ConnectionBroker $connectionBroker

	# Extract the session host names from the retrieved servers, strip the domain suffix, and sort them
	$strippedServerNames = $servers | Select-Object -ExpandProperty SessionHost -replace "\.shastahealth\.org$" | Sort-Object

	# Add the stripped server names to the global server array
	$fullServerArray.AddRange($strippedServerNames)
}

# Define the initialization function
function Initialize-ServerList {
	# Connect to the Remote Desktop Connection Broker
	$brokerArray = @(
		"rdbroker1.shastahealth.org"
		,"rdbroker2.shastahealth.org"
	)
	$collection = "medical"
	$fullServerArray = [System.Collections.ArrayList]::new()

	# Iterate through the connection brokers and retrieve the session hosts for each
	foreach ($broker in $brokerArray) {
		Add-ServersFromCollectionToArray($broker, $collection)
	}

	# Sort the full server array
	$fullServerArray.Sort()

	# Return the sorted server array
	return $fullServerArray
}

# Export the functions
Export-ModuleMember -Function 'Add-ServersFromCollectionToArray', 'Initialize-ServerList'