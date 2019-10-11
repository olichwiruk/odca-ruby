require 'odca/overlays/label_overlay'

RSpec.describe Odca::Overlays::LabelOverlay do
  let(:overlay) { described_class.new }

  describe '#to_h' do
    context 'label overlay has label attributes' do
      before(:each) do
        overlay.description = 'desc'
        overlay.role = 'role'
        overlay.purpose = 'purpose'
        overlay.language = 'en'

        overlay.add_label_attribute(
          described_class::LabelAttribute.new(
            name: 'attr_name', value: 'Cat | lab'
          )
        )
      end

      it 'returns filled hash' do
        expect(overlay.to_h).to eql(
          '@context' => 'https://odca.tech/overlays/v1',
          schema_base: '',
          type: 'spec/overlay/label/1.0',
          description: 'desc',
          issued_by: '',
          role: 'role',
          purpose: 'purpose',
          language: 'en',
          attr_labels: {
            'attr_name' => 'lab'
          },
          attr_categories: [:cat],
          category_labels: {
            cat: 'Cat'
          }
        )
      end
    end
  end

  describe '#add_label_attribute' do
    before(:each) do
      overlay.add_label_attribute(attribute)
    end

    context 'when label_attribute is provided correctly' do
      let(:attribute) do
        described_class::LabelAttribute.new(
          name: 'attr', value: 'cat | lab'
        )
      end

      it 'adds attribute to label_attributes array' do
        expect(overlay.label_attributes)
          .to contain_exactly(attribute)
      end
    end

    context 'when label_attribute is nil' do
      let(:attribute) { nil }

      it 'ignores label_attribute' do
        expect(overlay.label_attributes).to be_empty
      end
    end

    context 'when label_attribute name is empty' do
      let(:attribute) do
        described_class::LabelAttribute.new(
          name: ' ', value: 'cat | lab'
        )
      end

      it 'ignores label_attribute' do
        expect(overlay.label_attributes).to be_empty
      end
    end
  end

  context 'generating categories and labels collections' do
    before(:each) do
      overlay.add_label_attribute(
        described_class::LabelAttribute.new(
          name: 'attr_name', value: 'Cat | lab'
        )
      )
      overlay.add_label_attribute(
        described_class::LabelAttribute.new(
          name: 'sec_attr', value: 'Label'
        )
      )
    end

    describe '#attr_labels' do
      it 'returns hash of attribute_names and labels' do
        expect(overlay.__send__(:attr_labels))
          .to include(
            'attr_name' => 'lab',
            'sec_attr' => 'Label'
          )
      end
    end

    describe '#attr_categories' do
      it 'returns categories symbols' do
        expect(overlay.__send__(:attr_categories))
          .to contain_exactly(:cat)
      end
    end

    describe '#category_labels' do
      it 'returns hash of categories symbols and labels' do
        expect(overlay.__send__(:category_labels))
          .to include(cat: 'Cat')
      end
    end
  end

  describe described_class::LabelAttribute do
    let(:attribute) do
      described_class.new(name: 'attr_name', value: value)
    end

    context 'record contains one pipe' do
      let(:value) { 'C a t | lab' }

      it 'splits into category and label' do
        expect(attribute.category).to eql('C a t')
        expect(attribute.label).to eql('lab')
      end
    end

    context "record doesn't contain any pipes" do
      let(:value) { 'Label' }

      it 'sets label as value' do
        expect(attribute.category).to eql('')
        expect(attribute.label).to eql('Label')
      end
    end

    context 'record contains many pipes' do
      let(:value) { '| cat | lab' }

      it 'sets category and label as empty strings' do
        expect(attribute.category).to eql('')
        expect(attribute.label).to eql('')
      end
    end
  end
end
