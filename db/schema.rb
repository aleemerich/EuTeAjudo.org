# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110630224210) do

  create_table "amigo_bloqueados", :force => true do |t|
    t.integer  "amigo_id"
    t.integer  "amigo_id_bloq"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "motivo"
  end

  create_table "amigo_conversa_controles", :force => true do |t|
    t.integer  "amigo_id"
    t.integer  "conversa_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "flagNovidade", :default => 0
  end

  create_table "amigo_denuncias", :force => true do |t|
    t.integer  "amigo_id"
    t.integer  "amigo_id_denunciado"
    t.integer  "dialogo_id"
    t.text     "texto"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "amigos", :force => true do |t|
    t.string   "nomeCompleto"
    t.string   "email"
    t.string   "senha"
    t.string   "cidade"
    t.string   "estado"
    t.string   "cpf"
    t.string   "telefone"
    t.string   "profissao"
    t.integer  "nivelPermissao"
    t.string   "stringValidacao"
    t.datetime "dataValidacao"
    t.integer  "reenvioSenha"
    t.integer  "statusBloqueio"
    t.integer  "flagAvisos"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversas", :force => true do |t|
    t.string   "assunto"
    t.integer  "amigo_id"
    t.integer  "flagColaboracaoUnica"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dialogos", :force => true do |t|
    t.integer  "conversa_id"
    t.integer  "amigo_id"
    t.text     "texto"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_acessos", :force => true do |t|
    t.text     "ip"
    t.text     "email"
    t.text     "senha"
    t.text     "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
