.ONESHELL:

SHELL := /bin/bash
DIR   := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

define link
	[ ! -e "$(strip $(2))" -o -L "$(strip $(2))" -o -f "$(strip $(2))" ] \
		&& rm -f "$(strip $(2))"                                         \
		&& ln -s -n -T --force "$(strip $(1))" "$(strip $(2))"           \
	|| true
endef

define link_with_backup
	[ ! -e "$(strip $(2))" -o -L "$(strip $(2))" ] \
		&& rm -f "$(strip $(2))"                   \
		|| mv "$(strip $(2))" "$(strip $(2))~"     \
		|| true
	ln -s -n -T --force "$(strip $(1))" "$(strip $(2))" || true
endef

define copy_if_doesnt_exist
	[ ! -e "$(strip $(2))" ] && [ -e "$(strip $(1))" ] && cp "$(strip $(1))" "$(strip $(2))" || true
endef

define append
	cat "$(strip $(1))" >> "$(strip $(2))" || true
endef

define append_if_not_test
	diff "$(strip $(1)).TEST" <(grep -m 1 -f "$(strip $(1)).TEST" "$(strip $(2))") || \
		( $(call append, $(strip $(1)), $(strip $(2))) )
endef

all: home root etc

home:
	$(call link                , ${DIR}                                          , ${HOME}/.phdconf                     )
	$(call link                , ${HOME}/.phdconf/.bashrc-phd                    , ${HOME}/.bashrc-phd                  )
	$(call copy_if_doesnt_exist, ${HOME}/.phdconf/copy/.bashrc-ssh               , ${HOME}/.bashrc-ssh                  )
	$(call copy_if_doesnt_exist, ${HOME}/.bash_history                           , ${HOME}/.bash_history-phd            )
	$(call append_if_not_test  , ${HOME}/.phdconf/append/.bashrc                 , ${HOME}/.bashrc                      )
	$(call link                , ${HOME}/.phdconf/.gitconfig-phd                 , ${HOME}/.gitconfig-phd               )
	$(call append_if_not_test  , ${HOME}/.phdconf/append/.gitconfig              , ${HOME}/.gitconfig                   )
	$(call link                , ${HOME}/.phdconf/.profile-phd                   , ${HOME}/.profile-phd                 )
	$(call append_if_not_test  , ${HOME}/.phdconf/append/.profile                , ${HOME}/.profile                     )
	$(call link_with_backup    , ${HOME}/.phdconf/.nanorc                        , ${HOME}/.nanorc                      )
	$(call link_with_backup    , ${HOME}/.phdconf/.inputrc                       , ${HOME}/.inputrc                     )
	$(call link_with_backup    , ${HOME}/.phdconf/.screenrc                      , ${HOME}/.screenrc                    )
	$(call link_with_backup    , ${HOME}/.phdconf/.wgetrc                        , ${HOME}/.wgetrc                      )
	$(call link_with_backup    , ${HOME}/.phdconf/.xbindkeysrc                   , ${HOME}/.xbindkeysrc                 )
	$(call link_with_backup    , ${HOME}/.phdconf/.Xresources                    , ${HOME}/.Xresources                  )
	$(call link_with_backup    , ${HOME}/.phdconf/XTerm                          , ${HOME}/XTerm                        )
	mkdir -p ${HOME}/.config/fontconfig
	$(call link_with_backup    , ${HOME}/.phdconf/.config--fontconfig--fonts.conf, ${HOME}/.config/fontconfig/fonts.conf)
	$(call link_with_backup    , ${HOME}/.phdconf/.config--mpv                   , ${HOME}/.config/mpv                  )
	nano ${HOME}/.gitconfig

root:
	sudo make home

etc:
ifneq ($(shell id -u), 0)
	sudo make $@
else
	$(call link, ${DIR}                                            , /etc/.phdconf                     )
	$(call link, /etc/.phdconf/--etc--apt--preferences.d--phd      , /etc/apt/preferences.d/phd        )
	$(call link, /etc/.phdconf/--etc--apt--sources.list.d--phd.list, /etc/apt/sources.list.d/phd.list  )
	$(call link, /dev/null                                         , /etc/apt/sources.list.d/steam.list)
endif
