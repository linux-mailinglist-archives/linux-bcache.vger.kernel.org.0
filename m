Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 033EC1614C2
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Feb 2020 15:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgBQOb4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Feb 2020 09:31:56 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:33892 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgBQOb4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Feb 2020 09:31:56 -0500
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.15.2/8.15.2) with ESMTP id 01HEVl6B031607;
        Mon, 17 Feb 2020 14:31:47 GMT
From:   Nix <nix@esperi.org.uk>
To:     Postgarage Graz IT <it@postgarage.at>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: reads no longer cached since kernel 4.19
References: <b039d510-9b03-e6a3-499a-1dbe72764cbe@postgarage.at>
        <98d03769-c58d-98dc-64aa-7d8fbf39ceea@postgarage.at>
Emacs:  because one operating system isn't enough.
Date:   Mon, 17 Feb 2020 14:31:47 +0000
In-Reply-To: <98d03769-c58d-98dc-64aa-7d8fbf39ceea@postgarage.at> (Postgarage
        Graz's message of "Wed, 12 Feb 2020 07:02:28 +0100")
Message-ID: <87sgj9thd8.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-x.dcc-servers-Metrics: loom 104; Body=2 Fuz1=2 Fuz2=2
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12 Feb 2020, Postgarage Graz stated:

> On 10.02.20 17:10, Ville Aakko wrote:
>> Hi,
>> 
>> A fellow user responding here.
>> 
>> I've noticed similar behavior and have asked on this same mailing list
>> previously. See:
>> https://www.spinics.net/lists/linux-bcache/msg07859.html
>> 
>> Also seems there are other users with this issue on the Arch Forum,
>> where I have also started a discussion:
>> https://bbs.archlinux.org/viewtopic.php?id=250525
>> There is yet to be a single user to reply there (or on this mailing
>> list) claiming they have a working setup (for caching reads).
>> 
>> Judging from the Arch Linux thread, I have a hunch there were some
>> changes ~4.18, which broke read caching for many (all?) desktop users
>> (as anything which is flagged as readahed will not be cached, despite
>> setting sequential_cutoff). Also (again from the Arch thread) a
>> planned patch might enable expected read caching: "[PATCH 3/5] bcache:
>> add readahead cache policy options via sysfs interface" / see:
>> https://www.spinics.net/lists/linux-bcache/msg08074.html
>
> Indeed that patch works.
> Now I'm using the 5.6-rc1 kernel and the performance gain is huge.

Note: 4.19 had an *extra* bug as well, which eliminated all metadata
caching on some filesystems (like XFS, but IIRC not ext4). It was fixed
in v5.1 by commit dc7292a5bcb4c878b.

So you had two problems :)

(I've just moved to a readahead-caching kernel, and while I don't see
any performance gain yet, I'm sure it will come once the cache finishes
populating. It's certainly seeing more writes, 20GiB written in only two
days where before it took a month to write that much.)

Note: the readahead fix was well-timed, since it was only in v5.4 that
the Linux NFS client stopped hardwiring a readahead size of 15 times the
optimal read size, i.e., uh, 15MiB with most servers. That really would
have filled the bcache of the NFS server with a lot of junk.)
