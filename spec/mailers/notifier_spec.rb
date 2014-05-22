# -*- coding: utf-8 -*-
require 'spec_helper'

shared_examples_for Notifier do
  it 'render sender' do
    expect(@mail.from).to eql(['default@example.com'])
  end

  it 'render destination' do
    expect(@mail.to).to eql([@email.address])
  end  
end

describe Notifier do
  describe 'confirm' do
    before do
      @email = FactoryGirl.create(:email)
      @user = @email.user
      @mail = Notifier.confirm(@user)
    end

    it_behaves_like Notifier    

    it 'render subject' do 
      expect(@mail.subject).to eql('Confirme los avisos de su auto ' + @user.plate)
    end
        
    it 'show plate' do
      expect(@mail.body.encoded).to match(@user.plate)
    end
    
    it 'show confirmation url' do
      expect(@mail.body.encoded).to match(aviso_path(@user.id))
    end
  end

  describe 'welcome' do
    before do
      @email = FactoryGirl.create(:email)
      @user = @email.user
      @mail = Notifier.welcome(@user)
      @mail.body.encoded.gsub(/\r?\n/, " ")
    end

    it_behaves_like Notifier

    it 'render subject' do 
      expect(@mail.subject).to eql('Los avisos de su auto ' + @user.plate + ' estan confirmados')
    end
    
    it 'show plate' do
      expect(@mail.body.encoded).to match(@user.plate)
    end

    it 'show verificacion settings' do
      expect(@mail.body.encoded).to match('Verificación')
    end
    
    it 'show adeudos settings' do
      expect(@mail.body.encoded).to match('Pago de tenencias e infracciones')
    end
    
    it 'show no circula weekend settings' do
      expect(@mail.body.encoded).to match('Hoy no circula sabatino')
    end
  end
end
