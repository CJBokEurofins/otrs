# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Admin::CommunicationChannel::Sync;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::CommunicationChannel',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Sync registered communication channels in the system.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Syncing communication channels...</yellow>\n");

    my $CommunicationChannelObject = $Kernel::OM->Get('Kernel::System::CommunicationChannel');

    # Sync the channels.
    my %Result = $CommunicationChannelObject->ChannelSync(
        UserID => 1,
    );
    if (%Result) {
        if ( $Result{ChannelsAdded} ) {
            $Self->Print(
                sprintf( "<yellow>%s</yellow> channels were added.\n", scalar @{ $Result{ChannelsAdded} || [] } )
            );
        }
        if ( $Result{ChannelsUpdated} ) {
            $Self->Print(
                sprintf( "<yellow>%s</yellow> channels were updated.\n", scalar @{ $Result{ChannelsUpdated} || [] } )
            );
        }
        if ( $Result{ChannelsInvalid} ) {
            $Self->Print(
                sprintf( "<red>%s</red> channels are invalid.\n", scalar @{ $Result{ChannelsInvalid} || [] } )
            );
        }
    }
    else {
        $Self->Print("<yellow>All channels were already in sync with configuration.</yellow>\n");
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
