class_name FastUIAdEvent
extends FastUIEvent

@export_enum(
	"interstitial:0",
	"rewarded:1",
) var type: int = 0

func trigger(instigator: Node) -> void:
	match type:
		0:
			YandexAds.showInterstitialAd()
		1:
			YandexAds.showRewardedAd()
