# -*-makefile-*-
#
# Copyright (C) 2010 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_CT_NG) += ct-ng

#
# Paths and names
#
CT_NG_VERSION	:= $(call remove_quotes,$(PTXCONF_CT_NG_VERSION))
CT_NG		:= crosstool-ng-$(CT_NG_VERSION)
CT_NG_SUFFIX	:= tar.bz2
CT_NG_URL	:= http://ymorin.is-a-geek.org/download/crosstool-ng/$(CT_NG).$(CT_NG_SUFFIX)
CT_NG_SOURCE	:= $(SRCDIR)/$(CT_NG).$(CT_NG_SUFFIX)
CT_NG_DIR	:= $(BUILDDIR)/$(CT_NG)
CT_NG_LICENSE	:= unknown

CT_NG_CONFIG	:= $(call remove_quotes, $(PTXDIST_PLATFORMCONFIGDIR)/$(PTXCONF_CT_NG_CONFIG))

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(CT_NG_SOURCE):
	@$(call targetinfo)
	@$(call get, CT_NG)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/ct-ng.extract:
	@$(call targetinfo)
	@mkdir -p "$(CT_NG_DIR)"
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

ifdef PTXCONF_CT_NG
$(CT_NG_CONFIG):
	@echo
	@echo "*****************************************************************************"
	@echo "**** Please generate a ct-ng config with 'ptxdist menuconfig ct-ng' ****"
	@echo "*****************************************************************************"
	@echo
	@echo
	@exit 1
endif

$(STATEDIR)/ct-ng.prepare:
	@$(call targetinfo)

	@echo "Using ct-ng config file: $(CT_NG_CONFIG)"
	@install -m 644 $(CT_NG_CONFIG) $(CT_NG_DIR)/.config

	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/ct-ng.compile:
#	@$(call targetinfo)
#	@$(call world/compile, CT_NG)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/ct-ng.install:
#	@$(call targetinfo)
#	@$(call world/install, CT_NG)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/ct-ng.targetinstall:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/ct-ng.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, CT_NG)

# ----------------------------------------------------------------------------
# oldconfig / menuconfig
# ----------------------------------------------------------------------------

ct-ng_oldconfig ct-ng_menuconfig: $(STATEDIR)/ct-ng.extract $(STATEDIR)/host-ct-ng.install
	@if [ -e "$(CT_NG_CONFIG)" -a -e "$(CT_NG_DIR)/.config" ]; then \
		if [ "$(CT_NG_CONFIG)" -nt "$(CT_NG_DIR)/.config" ]; then \
			cp "$(CT_NG_CONFIG)" "$(CT_NG_DIR)/.config"; \
		else \
			cp "$(CT_NG_DIR)/.config" "$(CT_NG_CONFIG)"; \
		fi \
	elif [ -e "$(CT_NG_CONFIG)" ]; then \
		cp "$(CT_NG_CONFIG)" "$(CT_NG_DIR)/.config"; \
	elif [ -e "$(CT_NG_DIR)/.config" ]; then \
		cp "$(CT_NG_DIR)/.config"; \
	fi
	@cd "$(CT_NG_DIR)" && \
		$(CT_NG_PATH) $(CT_NG_ENV) ct-ng $(CT_NG_MAKEVARS) $(subst ct-ng_,,$@)
	@if cmp -s "$(CT_NG_DIR)/.config" "$(CT_NG_CONFIG)"; then \
		echo "ct-ng configuration unchanged"; \
	else \
		cp "$(CT_NG_DIR)/.config" "$(CT_NG_CONFIG)"; \
	fi

# vim: syntax=make
