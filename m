Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6012952659B
	for <lists+linux-bcache@lfdr.de>; Fri, 13 May 2022 17:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349635AbiEMPFg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 13 May 2022 11:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381006AbiEMPFe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 May 2022 11:05:34 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7826C25C78
        for <linux-bcache@vger.kernel.org>; Fri, 13 May 2022 08:05:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3807A218EF;
        Fri, 13 May 2022 15:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652454332; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U6HVmzH8SYjs77yuraUBUay4ps1F6fEulC1dIdAT5Gw=;
        b=gEl0/FtH5C8pH8467O85s5RXsHXNklxw/efisgk0AlwZiz5bkEv/byTGe934LfhmPRp9aU
        yWju6LmYHgwdZnGDaXAr+fCAVEGLILhU12/c+1CRPRl0p1G0dxFV/ccYkV+lmi9SJhJfmD
        zpaCdAwpy4enwOEr8zfGdp1U7ilKsk0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652454332;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U6HVmzH8SYjs77yuraUBUay4ps1F6fEulC1dIdAT5Gw=;
        b=fLlwtHwn88dRytKpb3SxUCx68qQVNE+FC+fDClxRCXy3bmX0dx6X++/AFVvD0AIMZXx86p
        EV9ZP8hRBWAZsvAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EF8DC13446;
        Fri, 13 May 2022 15:05:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UlZqKLpzfmIQHAAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 13 May 2022 15:05:30 +0000
Message-ID: <02224f42-1ccf-4537-ff07-53fe5c66b3af@suse.de>
Date:   Fri, 13 May 2022 23:05:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 2/2] bcache-tools: Correct super block version check codes
Content-Language: en-US
To:     yanhuan916@gmail.com
Cc:     dahefanteng@gmail.com, linux-bcache@vger.kernel.org
References: <1624584630-9283-1-git-send-email-yanhuan916@gmail.com>
 <1624584630-9283-2-git-send-email-yanhuan916@gmail.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <1624584630-9283-2-git-send-email-yanhuan916@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/25/21 9:30 AM, yanhuan916@gmail.com wrote:
> From: Huan Yan <yanhuan916@gmail.com>
>
> This patch add missing super block version below:
> BCACHE_SB_VERSION_CDEV_WITH_UUID
> BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> BCACHE_SB_VERSION_CDEV_WITH_FEATURES
> BCACHE_SB_VERSION_BDEV_WITH_FEATURES


Applied and complemented commit log. Thanks.


Coly Li


> ---
>   bcache.c | 22 +++++++++++++++-------
>   bcache.h |  3 ++-
>   lib.c    | 15 ++++++++++-----
>   make.c   |  8 ++++++--
>   show.c   |  6 ++++--
>   5 files changed, 37 insertions(+), 17 deletions(-)
>
> diff --git a/bcache.c b/bcache.c
> index 1c4cef9..62ed08d 100644
> --- a/bcache.c
> +++ b/bcache.c
> @@ -199,7 +199,8 @@ int tree(void)
>   	sprintf(out, "%s", begin);
>   	list_for_each_entry_safe(devs, n, &head, dev_list) {
>   		if ((devs->version == BCACHE_SB_VERSION_CDEV
> -		     || devs->version == BCACHE_SB_VERSION_CDEV_WITH_UUID)
> +		     || devs->version == BCACHE_SB_VERSION_CDEV_WITH_UUID
> +		     || devs->version == BCACHE_SB_VERSION_CDEV_WITH_FEATURES)
>   		    && strcmp(devs->state, BCACHE_BASIC_STATE_ACTIVE) == 0) {
>   			sprintf(out + strlen(out), "%s\n", devs->name);
>   			list_for_each_entry_safe(tmp, m, &head, dev_list) {
> @@ -231,7 +232,8 @@ int attach_both(char *cdev, char *backdev)
>   	if (ret != 0)
>   		return ret;
>   	if (type != BCACHE_SB_VERSION_BDEV
> -	    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET) {
> +	    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> +	    && type != BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
>   		fprintf(stderr, "%s is not an backend device\n", backdev);
>   		return 1;
>   	}
> @@ -244,7 +246,8 @@ int attach_both(char *cdev, char *backdev)
>   	if (strlen(cdev) != 36) {
>   		ret = detail_dev(cdev, &bd, &cd, NULL, &type);
>   		if (type != BCACHE_SB_VERSION_CDEV
> -		    && type != BCACHE_SB_VERSION_CDEV_WITH_UUID) {
> +		    && type != BCACHE_SB_VERSION_CDEV_WITH_UUID
> +		    && type != BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
>   			fprintf(stderr, "%s is not an cache device\n", cdev);
>   			return 1;
>   		}
> @@ -359,10 +362,13 @@ int main(int argc, char **argv)
>   		ret = detail_dev(devname, &bd, &cd, NULL, &type);
>   		if (ret != 0)
>   			return ret;
> -		if (type == BCACHE_SB_VERSION_BDEV) {
> +		if (type == BCACHE_SB_VERSION_BDEV
> +		    || type == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> +		    || type == BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
>   			return stop_backdev(devname);
>   		} else if (type == BCACHE_SB_VERSION_CDEV
> -			   || type == BCACHE_SB_VERSION_CDEV_WITH_UUID) {
> +			   || type == BCACHE_SB_VERSION_CDEV_WITH_UUID
> +			   || type == BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
>   			return unregister_cset(cd.base.cset);
>   		}
>   		return 1;
> @@ -408,7 +414,8 @@ int main(int argc, char **argv)
>   			return ret;
>   		}
>   		if (type != BCACHE_SB_VERSION_BDEV
> -		    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET) {
> +		    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> +		    && type != BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
>   			fprintf(stderr,
>   				"Only backend device is suppported\n");
>   			return 1;
> @@ -434,7 +441,8 @@ int main(int argc, char **argv)
>   			return ret;
>   		}
>   		if (type != BCACHE_SB_VERSION_BDEV
> -		    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET) {
> +		    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> +		    && type != BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
>   			fprintf(stderr,
>   				"Only backend device is suppported\n");
>   			return 1;
> diff --git a/bcache.h b/bcache.h
> index 2ae25ee..b10d4c0 100644
> --- a/bcache.h
> +++ b/bcache.h
> @@ -164,7 +164,8 @@ struct cache_sb {
>   static inline bool SB_IS_BDEV(const struct cache_sb *sb)
>   {
>   	return sb->version == BCACHE_SB_VERSION_BDEV
> -		|| sb->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET;
> +		|| sb->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> +		|| sb->version == BCACHE_SB_VERSION_BDEV_WITH_FEATURES;
>   }
>   
>   BITMASK(CACHE_SYNC,		struct cache_sb, flags, 0, 1);
> diff --git a/lib.c b/lib.c
> index 745dab6..ea1f18d 100644
> --- a/lib.c
> +++ b/lib.c
> @@ -281,10 +281,12 @@ int get_dev_bname(char *devname, char *bname)
>   int get_bname(struct dev *dev, char *bname)
>   {
>   	if (dev->version == BCACHE_SB_VERSION_CDEV
> -	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID)
> +	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID
> +	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_FEATURES)
>   		strcpy(bname, BCACHE_NO_SUPPORT);
>   	else if (dev->version == BCACHE_SB_VERSION_BDEV
> -		   || dev->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET)
> +		 || dev->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> +		 || dev->version == BCACHE_SB_VERSION_BDEV_WITH_FEATURES)
>   		return get_dev_bname(dev->name, bname);
>   	return 0;
>   }
> @@ -317,10 +319,12 @@ int get_backdev_attachpoint(char *devname, char *point)
>   int get_point(struct dev *dev, char *point)
>   {
>   	if (dev->version == BCACHE_SB_VERSION_CDEV
> -	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID)
> +	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID
> +	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_FEATURES)
>   		strcpy(point, BCACHE_NO_SUPPORT);
>   	else if (dev->version == BCACHE_SB_VERSION_BDEV
> -		   || dev->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET)
> +		 || dev->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> +		 || dev->version == BCACHE_SB_VERSION_BDEV_WITH_FEATURES)
>   		return get_backdev_attachpoint(dev->name, point);
>   	return 0;
>   }
> @@ -331,7 +335,8 @@ int cset_to_devname(struct list_head *head, char *cset, char *devname)
>   
>   	list_for_each_entry(dev, head, dev_list) {
>   		if ((dev->version == BCACHE_SB_VERSION_CDEV
> -		     || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID)
> +		     || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID
> +		     || dev->version == BCACHE_SB_VERSION_CDEV_WITH_FEATURES)
>   		    && strcmp(dev->cset, cset) == 0)
>   			strcpy(devname, dev->name);
>   	}
> diff --git a/make.c b/make.c
> index 39b381a..d3b4baa 100644
> --- a/make.c
> +++ b/make.c
> @@ -272,10 +272,14 @@ static void write_sb(char *dev, struct sb_context *sbc, bool bdev, bool force)
>   			ret = detail_dev(dev, &bd, &cd, NULL, &type);
>   			if (ret != 0)
>   				exit(EXIT_FAILURE);
> -			if (type == BCACHE_SB_VERSION_BDEV) {
> +			if (type == BCACHE_SB_VERSION_BDEV
> +			    || type == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> +			    || type == BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
>   				ret = stop_backdev(dev);
>   			} else if (type == BCACHE_SB_VERSION_CDEV
> -				|| type == BCACHE_SB_VERSION_CDEV_WITH_UUID) {
> +				   || type == BCACHE_SB_VERSION_CDEV_WITH_UUID
> +				   || type ==
> +				   BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
>   				ret = unregister_cset(cd.base.cset);
>   			} else {
>   				fprintf(stderr,
> diff --git a/show.c b/show.c
> index 6175f3f..15cdb95 100644
> --- a/show.c
> +++ b/show.c
> @@ -75,8 +75,9 @@ int show_bdevs_detail(void)
>   		if (strlen(devs->attachuuid) == 36) {
>   			cset_to_devname(&head, devs->cset, attachdev);
>   		} else if (devs->version == BCACHE_SB_VERSION_CDEV
> +			   || devs->version == BCACHE_SB_VERSION_CDEV_WITH_UUID
>   			   || devs->version ==
> -			   BCACHE_SB_VERSION_CDEV_WITH_UUID) {
> +			   BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
>   			strcpy(attachdev, BCACHE_NO_SUPPORT);
>   		} else {
>   			strcpy(attachdev, BCACHE_ATTACH_ALONE);
> @@ -135,8 +136,9 @@ int show_bdevs(void)
>   		if (strlen(devs->attachuuid) == 36) {
>   			cset_to_devname(&head, devs->cset, attachdev);
>   		} else if (devs->version == BCACHE_SB_VERSION_CDEV
> +			   || devs->version == BCACHE_SB_VERSION_CDEV_WITH_UUID
>   			   || devs->version ==
> -			   BCACHE_SB_VERSION_CDEV_WITH_UUID) {
> +			   BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
>   			strcpy(attachdev, BCACHE_NO_SUPPORT);
>   		} else {
>   			strcpy(attachdev, BCACHE_ATTACH_ALONE);


