Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12EE432022
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Oct 2021 16:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhJROtR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Oct 2021 10:49:17 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58742 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhJROtQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 10:49:16 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 87E9E21A7A;
        Mon, 18 Oct 2021 14:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634568424; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2J6N/dfVt+ftzDzONlbQ6HOF0MF6oIpCl849wsbfJI4=;
        b=dsTzZmYSMnpd2UYIBFKdaElpd8Y0Hm5WozH1SeSHePI+g+2P6hiE6RyxSfrEqo17N3HHvJ
        Kh9xTPUYVRhaDrcP7r8czOcalxCnl0fgbjG3lHJC7Fpar52tTl5ygokU8mQrHJuJ4tIDRl
        c6I2hd399XHuTWGlfaNBbXUiPFojgN4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634568424;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2J6N/dfVt+ftzDzONlbQ6HOF0MF6oIpCl849wsbfJI4=;
        b=cl7buG2teCW7vU8+RjzHSmnNiBcBiKI/F49P2hzBy1RoBF11vPVTFJ9Yco3reu5e/JxMp3
        Ty/88BEDUQ5InsBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8FB5A13E93;
        Mon, 18 Oct 2021 14:47:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mtAuF+eIbWHzCAAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 18 Oct 2021 14:47:03 +0000
Subject: Re: [PATCH V2] bcache: replace snprintf in show functions with
 sysfs_emit
To:     Qing Wang <wangqing@vivo.com>
References: <1634126301-2849-1-git-send-email-wangqing@vivo.com>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Message-ID: <f63d7139-8843-793a-dfb8-b368e57ce425@suse.de>
Date:   Mon, 18 Oct 2021 22:47:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1634126301-2849-1-git-send-email-wangqing@vivo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/13/21 7:58 PM, Qing Wang wrote:
> coccicheck complains about the use of snprintf() in sysfs show functions.
>
> Fix the following coccicheck warning:
> drivers/md/bcache/sysfs.h:54:12-20: WARNING: use scnprintf or sprintf.
>
> Implement sysfs_print() by sysfs_emit() and remove snprint() since no one
> uses it any more.
>
> Suggested-by: Coly Li <colyli@suse.de>
> Signed-off-by: Qing Wang <wangqing@vivo.com>

It looks fine to me. Let me add it into my for-test directory.

Thanks for the fix up.

Coly Li

> ---
>   drivers/md/bcache/sysfs.h | 18 ++++++++++++++++--
>   drivers/md/bcache/util.h  | 17 -----------------
>   2 files changed, 16 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/md/bcache/sysfs.h b/drivers/md/bcache/sysfs.h
> index 215df32..c1752ba
> --- a/drivers/md/bcache/sysfs.h
> +++ b/drivers/md/bcache/sysfs.h
> @@ -51,13 +51,27 @@ STORE(fn)								\
>   #define sysfs_printf(file, fmt, ...)					\
>   do {									\
>   	if (attr == &sysfs_ ## file)					\
> -		return snprintf(buf, PAGE_SIZE, fmt "\n", __VA_ARGS__);	\
> +		return sysfs_emit(buf, fmt "\n", __VA_ARGS__);	\
>   } while (0)
>   
>   #define sysfs_print(file, var)						\
>   do {									\
>   	if (attr == &sysfs_ ## file)					\
> -		return snprint(buf, PAGE_SIZE, var);			\
> +		return sysfs_emit(buf,						\
> +				__builtin_types_compatible_p(typeof(var), int)		\
> +					 ? "%i\n" :				\
> +				__builtin_types_compatible_p(typeof(var), unsigned int)	\
> +					 ? "%u\n" :				\
> +				__builtin_types_compatible_p(typeof(var), long)		\
> +					 ? "%li\n" :			\
> +				__builtin_types_compatible_p(typeof(var), unsigned long)\
> +					 ? "%lu\n" :			\
> +				__builtin_types_compatible_p(typeof(var), int64_t)	\
> +					 ? "%lli\n" :			\
> +				__builtin_types_compatible_p(typeof(var), uint64_t)	\
> +					 ? "%llu\n" :			\
> +				__builtin_types_compatible_p(typeof(var), const char *)	\
> +					 ? "%s\n" : "%i\n", var);	\
>   } while (0)
>   
>   #define sysfs_hprint(file, val)						\
> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
> index b64460a..fecdea1
> --- a/drivers/md/bcache/util.h
> +++ b/drivers/md/bcache/util.h
> @@ -340,23 +340,6 @@ static inline int bch_strtoul_h(const char *cp, long *res)
>   	_r;								\
>   })
>   
> -#define snprint(buf, size, var)						\
> -	snprintf(buf, size,						\
> -		__builtin_types_compatible_p(typeof(var), int)		\
> -		     ? "%i\n" :						\
> -		__builtin_types_compatible_p(typeof(var), unsigned int)	\
> -		     ? "%u\n" :						\
> -		__builtin_types_compatible_p(typeof(var), long)		\
> -		     ? "%li\n" :					\
> -		__builtin_types_compatible_p(typeof(var), unsigned long)\
> -		     ? "%lu\n" :					\
> -		__builtin_types_compatible_p(typeof(var), int64_t)	\
> -		     ? "%lli\n" :					\
> -		__builtin_types_compatible_p(typeof(var), uint64_t)	\
> -		     ? "%llu\n" :					\
> -		__builtin_types_compatible_p(typeof(var), const char *)	\
> -		     ? "%s\n" : "%i\n", var)
> -
>   ssize_t bch_hprint(char *buf, int64_t v);
>   
>   bool bch_is_zero(const char *p, size_t n);

