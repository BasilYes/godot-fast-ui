class_name FastUIAdEvent
extends FastUIEvent

@export_enum(
	"interstitial:0",
	"rewarded:1",
) var type: int = 0

func trigger(instigator: Node) -> void:
	var ads: = instigator.get_tree().root.get_node_or_null("YandexAds")
	if ads:
		match type:
			0:
				ads.showInterstitialAd()
			1:
				ads.showRewardedAd()
