Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942763B6671
	for <lists+linux-bcache@lfdr.de>; Mon, 28 Jun 2021 18:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhF1QMU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 28 Jun 2021 12:12:20 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36910 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbhF1QMU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 28 Jun 2021 12:12:20 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2647F224CD;
        Mon, 28 Jun 2021 16:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624896594; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YUS6O67lU4Iq8/21kngIUA8Pq/a3N+hNl5++pAcsX64=;
        b=NpZuvJvDCboNzrVgd8wvh9pNcCfHIVWvFv0odlnSkjps2ufYGmLly/cwQd+42r3vyaekqQ
        BrDK5ZBLQQrSeTxfWBggNKUrtdMPqQaO9lJdCY4k35tBOb2Gjfs5xmNMSZbP+Fd29fI8Ir
        YRuGGVdqNqZXd1JpfyAtNAmy7avLsfQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624896594;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YUS6O67lU4Iq8/21kngIUA8Pq/a3N+hNl5++pAcsX64=;
        b=/I0VaPGGKcYGYntJ6H2Y3KoHoaAk8IyljG6xXcYl4Qr6RH57IdDvoLvQrSadBr4M1rpbVy
        FU+aa15w9y76dwAA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 4D8E711906;
        Mon, 28 Jun 2021 16:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624896594; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YUS6O67lU4Iq8/21kngIUA8Pq/a3N+hNl5++pAcsX64=;
        b=NpZuvJvDCboNzrVgd8wvh9pNcCfHIVWvFv0odlnSkjps2ufYGmLly/cwQd+42r3vyaekqQ
        BrDK5ZBLQQrSeTxfWBggNKUrtdMPqQaO9lJdCY4k35tBOb2Gjfs5xmNMSZbP+Fd29fI8Ir
        YRuGGVdqNqZXd1JpfyAtNAmy7avLsfQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624896594;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YUS6O67lU4Iq8/21kngIUA8Pq/a3N+hNl5++pAcsX64=;
        b=/I0VaPGGKcYGYntJ6H2Y3KoHoaAk8IyljG6xXcYl4Qr6RH57IdDvoLvQrSadBr4M1rpbVy
        FU+aa15w9y76dwAA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id L4r5CFH02WCcQwAALh3uQQ
        (envelope-from <colyli@suse.de>); Mon, 28 Jun 2021 16:09:53 +0000
Subject: Re: [PATCH 1/2] bcache-tools: make --discard a per device option
To:     yanhuan916@gmail.com
Cc:     dahefanteng@gmail.com, linux-bcache@vger.kernel.org
References: <1624584630-9283-1-git-send-email-yanhuan916@gmail.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <c9dd7434-151e-0f6b-0e1b-8f2cf782010d@suse.de>
Date:   Tue, 29 Jun 2021 00:09:51 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1624584630-9283-1-git-send-email-yanhuan916@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/25/21 9:30 AM, yanhuan916@gmail.com wrote:
> From: Huan Yan <yanhuan916@gmail.com>
>
> This patch make --discard option more flexible, it can be indicated after each
> backing or cache device.

NACK.

Reason 1,  Only cache device requires discard in bcache-tools. Backing
device will be handled by upper layer like mkfs.
Reason 2, the patch format does not follow current bcache-tools patch
format style.

Coly Li

> ---
>  make.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 48 insertions(+), 14 deletions(-)
>
> diff --git a/make.c b/make.c
> index 34d8011..39b381a 100644
> --- a/make.c
> +++ b/make.c
> @@ -402,6 +402,18 @@ static void write_sb(char *dev, struct sb_context *sbc, bool bdev, bool force)
>  		       (unsigned int) sb.version,
>  		       sb.block_size,
>  		       data_offset);
> +
> +		/* Attempting to discard backing device
> +		 */
> +		if (discard) {
> +			if (blkdiscard_all(dev, fd) < 0) {
> +				fprintf(stderr,
> +					"Failed to discard device %s, %s\n",
> +					dev, strerror(errno));
> +				exit(EXIT_FAILURE);
> +			}
> +		}
> +
>  		putchar('\n');
>  	} else {
>  		if (nvdimm_meta)
> @@ -446,8 +458,15 @@ static void write_sb(char *dev, struct sb_context *sbc, bool bdev, bool force)
>  
>  		/* Attempting to discard cache device
>  		 */
> -		if (discard)
> -			blkdiscard_all(dev, fd);
> +		if (discard) {
> +			if (blkdiscard_all(dev, fd) < 0) {
> +				fprintf(stderr,
> +					"Failed to discard device %s, %s\n",
> +					dev, strerror(errno));
> +				exit(EXIT_FAILURE);
> +			}
> +		}
> +
>  		putchar('\n');
>  	}
>  
> @@ -660,21 +679,27 @@ static unsigned int get_blocksize(const char *path)
>  int make_bcache(int argc, char **argv)
>  {
>  	int c;
> -	unsigned int i;
> +	unsigned int i, n;
>  	int cdev = -1, bdev = -1, mdev = -1;
>  	unsigned int ncache_devices = 0, ncache_nvm_devices = 0;
>  	unsigned int nbacking_devices = 0;
>  	char *cache_devices[argc];
>  	char *cache_nvm_devices[argc];
>  	char *backing_devices[argc];
> +	bool cache_devices_discard[argc];
> +	bool backing_devices_discard[argc];
> +	bool *device_discard = NULL;
>  	char label[SB_LABEL_SIZE] = { 0 };
>  	unsigned int block_size = 0, bucket_size = 1024;
> -	int writeback = 0, discard = 0, wipe_bcache = 0, force = 0;
> +	int writeback = 0, wipe_bcache = 0, force = 0;
>  	unsigned int cache_replacement_policy = 0;
>  	uint64_t data_offset = BDEV_DATA_START_DEFAULT;
>  	uuid_t set_uuid;
>  	struct sb_context sbc;
>  
> +	memset(cache_devices_discard, 0, sizeof(cache_devices_discard));
> +	memset(backing_devices_discard, 0, sizeof(backing_devices_discard));
> +
>  	uuid_generate(set_uuid);
>  
>  	struct option opts[] = {
> @@ -685,10 +710,8 @@ int make_bcache(int argc, char **argv)
>  		{ "block",		1, NULL,	'w' },
>  		{ "writeback",		0, &writeback,	1 },
>  		{ "wipe-bcache",	0, &wipe_bcache,	1 },
> -		{ "discard",		0, &discard,	1 },
> -		{ "cache_replacement_policy", 1, NULL, 'p' },
> +		{ "discard",		0, NULL,	'd' },
>  		{ "cache-replacement-policy", 1, NULL, 'p' },
> -		{ "data_offset",	1, NULL,	'o' },
>  		{ "data-offset",	1, NULL,	'o' },
>  		{ "cset-uuid",		1, NULL,	'u' },
>  		{ "help",		0, NULL,	'h' },
> @@ -710,6 +733,10 @@ int make_bcache(int argc, char **argv)
>  		case 'M':
>  			mdev = 1;
>  			break;
> +		case 'd':
> +			if (device_discard)
> +				*device_discard = true;
> +			break;
>  		case 'b':
>  			bucket_size =
>  				hatoi_validate(optarg, "bucket size", UINT_MAX);
> @@ -762,15 +789,20 @@ int make_bcache(int argc, char **argv)
>  			}
>  
>  			if (bdev > 0) {
> -				backing_devices[nbacking_devices++] = optarg;
> -				printf("backing_devices[%d]: %s\n", nbacking_devices - 1, optarg);
> +				n = nbacking_devices++;
> +				backing_devices[n] = optarg;
> +				printf("backing_devices[%d]: %s\n", n, optarg);
> +				device_discard = &backing_devices_discard[n];
>  				bdev = -1;
>  			} else if (cdev > 0) {
> -				cache_devices[ncache_devices++] = optarg;
> -				printf("cache_devices[%d]: %s\n", ncache_devices - 1, optarg);
> +				n = ncache_devices++;
> +				cache_devices[n] = optarg;
> +				printf("cache_devices[%d]: %s\n", n, optarg);
> +				device_discard = &cache_devices_discard[n];
>  				cdev = -1;
>  			} else if (mdev > 0) {
> -				cache_nvm_devices[ncache_nvm_devices++] = optarg;
> +				n = ncache_nvm_devices++;
> +				cache_nvm_devices[n] = optarg;
>  				mdev = -1;
>  			}
>  			break;
> @@ -806,7 +838,6 @@ int make_bcache(int argc, char **argv)
>  	sbc.block_size = block_size;
>  	sbc.bucket_size = bucket_size;
>  	sbc.writeback = writeback;
> -	sbc.discard = discard;
>  	sbc.wipe_bcache = wipe_bcache;
>  	sbc.cache_replacement_policy = cache_replacement_policy;
>  	sbc.data_offset = data_offset;
> @@ -814,13 +845,16 @@ int make_bcache(int argc, char **argv)
>  	sbc.label = label;
>  	sbc.nvdimm_meta = (ncache_nvm_devices > 0) ? true : false;
>  
> -	for (i = 0; i < ncache_devices; i++)
> +	for (i = 0; i < ncache_devices; i++) {
> +		sbc.discard = cache_devices_discard[i];
>  		write_sb(cache_devices[i], &sbc, false, force);
> +	}
>  
>  	for (i = 0; i < nbacking_devices; i++) {
>  		check_data_offset_for_zoned_device(backing_devices[i],
>  						   &sbc.data_offset);
>  
> +		sbc.discard = backing_devices_discard[i];
>  		write_sb(backing_devices[i], &sbc, true, force);
>  	}
>  

