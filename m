Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90E439A3F3
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Jun 2021 17:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhFCPHM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 3 Jun 2021 11:07:12 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:43478 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhFCPHL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Jun 2021 11:07:11 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 75E2E219FA;
        Thu,  3 Jun 2021 15:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622732726; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c9rvAE/4osh3BA64Pa7cCWzYRjC8aGEi7Q01jPdyPWU=;
        b=g8HzEvpA58+FfY2z5OJqrNYIyCWzrDnb+SNYFGHa7HJ7zirOqZSDuJqD2F9OXIAmueefQY
        WT0Z13QCBHgXCjT7v4lBYaHmdE7IixBxUExntsqU9lXbMtzWY9XzDpxJanSnMgpmqzh4RS
        XXkEy23LlddV4Xp/G4EXhUB82A6j96Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622732726;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c9rvAE/4osh3BA64Pa7cCWzYRjC8aGEi7Q01jPdyPWU=;
        b=Gcnop9y8HfT+Nk01V72wqycozsKo8mapE7K7mel1lKn9WGnaRNs5Nk79sWqOragnY4DwwG
        HdiQc5tPykWyGhAQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 75DDF118DD;
        Thu,  3 Jun 2021 15:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622732726; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c9rvAE/4osh3BA64Pa7cCWzYRjC8aGEi7Q01jPdyPWU=;
        b=g8HzEvpA58+FfY2z5OJqrNYIyCWzrDnb+SNYFGHa7HJ7zirOqZSDuJqD2F9OXIAmueefQY
        WT0Z13QCBHgXCjT7v4lBYaHmdE7IixBxUExntsqU9lXbMtzWY9XzDpxJanSnMgpmqzh4RS
        XXkEy23LlddV4Xp/G4EXhUB82A6j96Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622732726;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c9rvAE/4osh3BA64Pa7cCWzYRjC8aGEi7Q01jPdyPWU=;
        b=Gcnop9y8HfT+Nk01V72wqycozsKo8mapE7K7mel1lKn9WGnaRNs5Nk79sWqOragnY4DwwG
        HdiQc5tPykWyGhAQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id Nrf2ErXvuGA6WwAALh3uQQ
        (envelope-from <colyli@suse.de>); Thu, 03 Jun 2021 15:05:25 +0000
Subject: Re: [PATCH] bcache-tools: bcache-export-cached doesn't match backing
 device w/ offset, features
To:     Marc Smith <msmith626@gmail.com>,
        linux-bcache <linux-bcache@vger.kernel.org>
References: <CAH6h+he=rxPq9E8zmenmLp9vc9X4D1-6OQqVm0XyeMei3uLgqg@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <c86559d8-f13b-dd0d-f1f1-ea992a898b8b@suse.de>
Date:   Thu, 3 Jun 2021 23:05:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CAH6h+he=rxPq9E8zmenmLp9vc9X4D1-6OQqVm0XyeMei3uLgqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/12/21 3:06 AM, Marc Smith wrote:
> updated the awk snippet used in 'bcache-export-cached' so it matches the three
> current superblock versions of a "backing" device (BCACHE_SB_VERSION_BDEV,
> BCACHE_SB_VERSION_BDEV_WITH_OFFSET, BCACHE_SB_VERSION_BDEV_WITH_FEATURES)
>
> Signed-off-by: Marc A. Smith <marc.smith@quantum.com>
> ---
>  bcache-export-cached | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/bcache-export-cached b/bcache-export-cached
> index b345922..e6c1bc3 100644
> --- a/bcache-export-cached
> +++ b/bcache-export-cached
> @@ -19,7 +19,7 @@ for slave in "/sys/class/block/$DEVNAME/slaves"/*; do
>              $1 == "dev.uuid" { uuid=$2; }
>              $1 == "dev.label" && $2 != "(empty)" { label=$2; }
>              END {
> -                if (sbver == 1 && uuid) {
> +                if ((sbver == 1 || sbver == 4 || sbver == 6) && uuid) {
>                      print("CACHED_UUID=" uuid)
>                      if (label) print("CACHED_LABEL=" label)
>                      exit(0)

Applied. Thanks.

Coly Li
