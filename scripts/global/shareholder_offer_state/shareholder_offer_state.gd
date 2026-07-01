extends Node

# tells cell_prisoner_cretor to await offer card being chose
var await_user_choose_shareholder_offer_before_create : bool = false
signal create_prisoner_cells_user_chose_shareholder_offer()

## ITEM OFFER SIGNALS ##
# lets useable item spawner know to spawn an item
signal spawn_item_to_offer(useable_offer_item : UseableOfferItem)

signal create_item_offer_demand()
signal recieve_item_offer_demand(demand_constructor : ItemOfferDemandConstructor)
signal item_offer_success()


##### item offer #####
var items_to_offer = [
	UseableOfferItem.new('defect_shot','Decreases a chosen stat on a cell container by 15 percant, 3 charges total' ),
	UseableOfferItem.new('hidden_shot', 'Reveals all hidden stats on a cell container.'),
	UseableOfferItem.new('steroid', 'Increases the clean and defect values of a cell container by 30 percant'),
	UseableOfferItem.new('ice_cube', 'Freezes a cell for one turn. Frozen cells do not age, gain defects, or allow player interaction.'),
	UseableOfferItem.new('scissors', 'Cut off a chosen stat from a cell.'),
]
######################
