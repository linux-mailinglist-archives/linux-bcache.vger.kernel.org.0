Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219151F52C1
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Jun 2020 13:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgFJLCQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Jun 2020 07:02:16 -0400
Received: from mout.gmx.net ([212.227.17.20]:35569 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728304AbgFJLCP (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Jun 2020 07:02:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1591786932;
        bh=ttBM7J9yVPVu7OtoFEoCDb9EA6n/JgIWm7+/+T307bE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=jzY7s9DdyAK7JExSxSspR/3nyrTfdxcokfUpxfXRruRTZwKvpF1Luf6JRdepi8KLy
         Iv46edikQNolzdamHVaJvnzb2F07stpatzV6QYOtWDD6kirYiwSn2ky9NXwd6Yfzgf
         cL3DzUV8h7665KcIFwC3ZdggPNkiq8rxgfXfrang=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from t460-skr.localnet ([194.94.225.9]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M9Wyy-1joS8d3lYq-005Zt5; Wed, 10
 Jun 2020 13:02:12 +0200
From:   Stefan K <shadow_7@gmx.net>
To:     linux-bcache@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: bcachefs status update (it's done cooking; let's get this sucker merged)
Date:   Wed, 10 Jun 2020 13:02:10 +0200
Message-ID: <3828047.K31vBF4JiT@t460-skr>
In-Reply-To: <20190610191420.27007-1-kent.overstreet@gmail.com>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:kfmuR9y3kJQnguv0hXbIEWK6EjZe7CMg63tLFAsmgnk1CyBQcYT
 4HgJx50ccvdq1C8RjDExz0iDklIRbJKtZZCgBG3KE6VnXytsiWbOnDO8DknzqQdTH+Fm0h9
 uyTmefydTktose1G05KL2e26YrPLIRkKHm437dSq/C8d6gNbZVP0q6hU+aA032G0oOASuRI
 lm0SdZ3+L7N28iyBx9qjw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:DFa3HGxPvXs=:vArwvnoYYlxz1cgOrVBVOZ
 gDyJL7Qh81E+APlE2br2I15pzvIa2JWo/JJQd4BURW9kI+ewcaQ//PSOlIut1lV/lB2QccVSm
 UE8t8Ttj742buvhJl/LPgrhoDUQI8bGP0DOuGoS5vXxeTO+RA9bZ3sOtqx6diat21b0bXmZWD
 GQuuplCEYL0DIjb6j53kshM4IjZjEhgWyZrPWEG1Q5LOcj+9It/2evqCiw3xfqgcliW2ohsvV
 VvTyiDYg49xsyFmWUMX7sBbYrjIH6eH74sXqJCcEDOFQbQsgOS2uZ6ErwxxSJ+1Mg5baN91Ck
 qHPGDdAjUNy+xStrBOQZrAq3H5sWIEbMmFa026Hx4fE0PHDKgkT+qFXSd+mUEM44xN7ourBoV
 0TS0dKcECkX6K5T6aNb39vXmbrnZj+0KrtcJ3Ltei/oDAgpi5TgDfr/LsyqCKU4oQof6QxQjW
 122eB6cB7d0gyageMnbEIRlUpWkxD3UrAsXxa4Ux23s9S3pLsAdIMcg2PnY5C49VveYLNOME7
 IdnkOzhrEI+gCdsKq13Z7v2N+OQtxRZpGubDrPMKajGDOC+mJI/YtTQbiKTKGSNvtcZC5DDxy
 IlKBCITGawXDN1/162izb7HkX/iZWw7i6Fidjy5V5ODvxbnv35aMIueGc3M3Asp0h9jH+ES1N
 VViEmVnrrp0fAmml7DRtxfN7YeyQIzD1CIFEGrMZ6hijBm+pHNBp/xF7ZMa0ONCr/CSAPSCTl
 Jf/Uiz0vDeXJa7faWpQ8Y4LdPSGk3m718QuMOYjlTLdcB/wmp6U1q23SzgysqHspD7C1QWgPo
 0y1tt7d0o8PUACrKPA2MlK4qDSYGPdalAGWB/XtX6pLdqupnQSI1FLTAiFR5cRIjnMecVJNWS
 0BZbFraZAi8q5KT6yxa6g25F5jQuMElljI28TFJPG643HzNuhD62rXUkDPQ15TzcPmD9oWnU2
 jX4YGR3lWcHXWsJBJ8i9Y+6+Kugyh3vfxbvh5tIM002jnB20qsLfEV5TtrMbf5JxZtxOA53oq
 ig/9mOcqtndkcofH9M2DG0ITzpcI6jd/PsBzLdOL1CWrOkyWl35+iEpiEz/stvMBILmYnSXOg
 Pp+uLM5dR11sw8G+n6UIJVfa4pFAlQNvIjxEKy9gZP7BTQFSnZEMGA7EP4Jt0zp0JuYY6HnV9
 50dx3aWSRIHrF7eY9HWtm2Zg4LO/C7T/zpcJxlqrKzvBZHqys7nOX0+mzRdKSD8G3ntGY=
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

... one year later ...

what is the status now? the latest update on patreon is a few month old.
What are the blockers to merge bcachefs into the kernel?

I hope that the bcachefs thing will be merged soon.

best regards
Stefan


(I'm shortening the cc-list)

On Monday, June 10, 2019 9:14:08 PM CEST Kent Overstreet wrote:
> Last status update: https://lkml.org/lkml/2018/12/2/46
>
> Current status - I'm pretty much running out of things to polish and exc=
uses to
> keep tinkering. The core featureset is _done_ and the list of known outs=
tanding
> bugs is getting to be short and unexciting. The next big things on my to=
do list
> are finishing erasure coding and reflink, but there's no reason for merg=
ing to
> wait on those.
>
> So. Here's my bcachefs-for-review branch - this has the minimal set of p=
atches
> outside of fs/bcachefs/. My master branch has some performance optimizat=
ions for
> the core buffered IO paths, but those are fairly tricky and invasive so =
I want
> to hold off on those for now - this branch is intended to be more or les=
s
> suitable for merging as is.
>
> https://evilpiepirate.org/git/bcachefs.git/log/?h=3Dbcachefs-for-review
>
> The list of non bcachefs patches is:
>
> closures: fix a race on wakeup from closure_sync
> closures: closure_wait_event()
> bcache: move closures to lib/
> bcache: optimize continue_at_nobarrier()
> block: Add some exports for bcachefs
> Propagate gfp_t when allocating pte entries from __vmalloc
> fs: factor out d_mark_tmpfile()
> fs: insert_inode_locked2()
> mm: export find_get_pages()
> mm: pagecache add lock
> locking: SIX locks (shared/intent/exclusive)
> Compiler Attributes: add __flatten
>
> Most of the patches are pretty small, of the ones that aren't:
>
>  - SIX locks have already been discussed, and seem to be pretty uncontro=
versial.
>
>  - pagecache add lock: it's kind of ugly, but necessary to rigorously pr=
event
>    page cache inconsistencies with dio and other operations, in particul=
ar
>    racing vs. page faults - honestly, it's criminal that we still don't =
have a
>    mechanism in the kernel to address this, other filesystems are suscep=
tible to
>    these kinds of bugs too.
>
>    My patch is intentionally ugly in the hopes that someone else will co=
me up
>    with a magical elegant solution, but in the meantime it's an "it's ug=
ly but
>    it works" sort of thing, and I suspect in real world scenarios it's g=
oing to
>    beat any kind of range locking performance wise, which is the only
>    alternative I've heard discussed.
>
>  - Propaget gfp_t from __vmalloc() - bcachefs needs __vmalloc() to respe=
ct
>    GFP_NOFS, that's all that is.
>
>  - and, moving closures out of drivers/md/bcache to lib/.
>
> The rest of the tree is 62k lines of code in fs/bcachefs. So, I obviousl=
y won't
> be mailing out all of that as patches, but if any code reviewers have
> suggestions on what would make that go easier go ahead and speak up. The=
 last
> time I was mailing things out for review the main thing that came up was=
 ioctls,
> but the ioctl interface hasn't really changed since then. I'm pretty con=
fident
> in the on disk format stuff, which was the other thing that was mentione=
d.
>
> ----------
>
> This has been a monumental effort over a lot of years, and I'm _really_ =
happy
> with how it's turned out. I'm excited to finally unleash this upon the w=
orld.
>



