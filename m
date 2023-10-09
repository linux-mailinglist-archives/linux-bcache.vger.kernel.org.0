Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D625A7BD479
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Oct 2023 09:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345403AbjJIHi3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Oct 2023 03:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345391AbjJIHi2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Oct 2023 03:38:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5BAA6
        for <linux-bcache@vger.kernel.org>; Mon,  9 Oct 2023 00:38:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C2CC433C8;
        Mon,  9 Oct 2023 07:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696837107;
        bh=cDp2Y1xY9alsZtf+wxyGW53+PTLCvKmlEcosYhmvC2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRO08DtVsOLXuFdjnN2hPsCUZEQJghlcuOVfmH6N/ToIUF+6s1Hb4BlHkmoLsljpA
         pu5GorxlpTVBOBtwCLTB5ud+blqTOFzGp1eM83uzWFQtFVwiNq5YyYPtpVq1liK0kP
         rP5MBGhYCKwMRsSholEJwEaMBlBFOe+ivdbugfwamXsZxAjWJBMa2TfzSestBIKzSI
         RvdgN+ESLAT1xdTRYBscxMdwrvUvySd6HPDai5R741xxeAjgp8fd6U1UxoqX6DPFmC
         Dm88zfZfTodgTZpGdL8f/G7+TPA8XaA2ZEBNZfdqeeiSuok7YpiYkS/eZkgcEpEKDD
         BBsmj/k7gBIyQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Christian Brauner <brauner@kernel.org>, Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH] bcache: Fixup error handling in register_cache()
Date:   Mon,  9 Oct 2023 09:38:20 +0200
Message-Id: <20231009-sprechen-innenansicht-8a0a39ef5c9b@brauner>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231004093757.11560-1-jack@suse.cz>
References: <20231004093757.11560-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1376; i=brauner@kernel.org; h=from:subject:message-id; bh=cDp2Y1xY9alsZtf+wxyGW53+PTLCvKmlEcosYhmvC2U=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaQqr72e3rd85lzmaq9vz6ynsYn8mpbwWpJ589/dk4TmxOyu C42u6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAbhIOiPDBSWORx/TM/f/ZRfv1igyV1 U4e0rgy5bjBjvt+abcOmR1nZFhe3P8oooV+fcWCTDxsk7tX7Jy2pV0gU+Kq3VOe9ucYJbiAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, 04 Oct 2023 11:37:57 +0200, Jan Kara wrote:
> Coverity has noticed that the printing of error message in
> register_cache() uses already freed bdev_handle to get to bdev. In fact
> the problem has been there even before commit "bcache: Convert to
> bdev_open_by_path()" just a bit more subtle one - cache object itself
> could have been freed by the time we looked at ca->bdev and we don't
> hold any reference to bdev either so even that could in principle go
> away (due to device unplug or similar). Fix all these problems by
> printing the error message before closing the bdev.
> 
> [...]

Applied to the vfs.super branch of the vfs/vfs.git tree.
Patches in the vfs.super branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.super

[1/1] bcache: Fixup error handling in register_cache()
      https://git.kernel.org/vfs/vfs/c/cc82d9a7a3d0
