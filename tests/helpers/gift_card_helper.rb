module GiftCardHelper
  NUMBERS = {
    valid: %w[
      R984690421528 R248990900551 R297427831465 R225977321932 R792870322272
      R135912355115 R963109834715 R495635333895 R236432439565 R508330482734
      R039514035292"
    ],
    insufficient_funds: %w[ R299267428027 ],
    invalid: %w[ R999999999999 ]
  }
  def gift_card_number(type: :valid)
    NUMBERS[type][-1]
  end
end
