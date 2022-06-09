class OptionsFact{
  static List<Map<String, Object>> optionsFact = [
    /*{
    'key': 'age',
    'value': ['other'],
  },*/ //Age is obilgatory
    {
      'key': 'gender',
      'value': ['female', 'male', 'non-binary', 'other'],
    },
    {
      'key': 'beliefsystem',
      'value': [
        'christian',
        'muslim',
        'budhist',
        'hindu',
        'jaiinist',
        'spiritual',
        'atheist',
        'agnostic',
        'other'
      ],
    },
    {
      'key': 'culture',
      'value': ['western', 'middle east', 'east asian', 'other'],
    },
    {
      'key': 'personality type',
      'value': [
        'intj',
        'intp',
        'entj',
        'entp',
        'infj',
        'infp',
        'enfj',
        'enfp',
        'istj',
        'isfj',
        'estj',
        'esfj',
        'istp',
        'isfp',
        'estp',
        'esfp',
        'other'
      ],
    },
    {
      'key': 'zodiac',
      'value': [
        'libra',
        'virgo',
        'aries',
        'gemini',
        'pisces',
        'scorpio',
        'taurus',
        'leo',
        'sagittarius',
        'capricorn',
        'aquarius',
        'cancer',
        'other'
      ],
    },
    {
      'key': 'other',
      'value': ['other'],
    }
  ];

  static List<Map<String, Object>> get getOptionsFact {
    return optionsFact;
  }
}